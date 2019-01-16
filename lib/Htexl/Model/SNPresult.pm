package Htexl::Model::SNPresult;
use Mojo::Base -base;

use Mojo::Pg;
use POSIX qw(strftime);
use Htexl::Model::Common qw/currentDate normalizeDate sheet2collection/;
use Data::Dumper;

has pg => sub {Mojo::Pg->new};

has item_tbl => 'ar_item_info';

has snp_tbl => 'ar_snp_result';


# 将xls检测结果文件导入到数据库
sub xlstoDB {
	my ($self, $xls) = @_;

	my ($coll) = sheet2collection($xls);

	unless($coll->first->{'接样日期'}){
		my $recei_date = (split /[_\-]+/, $xls)[-3];  # 接样日期在文件名中
      
		$recei_date = $recei_date =~ /\d+/ ? normalizeDate($recei_date) : currentDate();
		$coll->map(sub{         # 为xls表中的每项添加接样时间
			$_->{'接样日期'} = $recei_date;
		});
	}
	my $rt = $coll->map(sub{ $self->snpInsert($_) });    # Insert into db'
    my $ok = $rt->grep(sub { $_->[1] == 1 }); # 成功插入的样本
    return wantarray ? @{$ok->map(sub{$_->[0]})->to_array} : $ok->size eq $rt->size ? 1 : 0;
}


# 将一项检测结果插入到数据库中
sub snpInsert{
    my ($self, $hashref) = @_;

    my $db = $self->pg->db;
    my $item_info = 'ar_item_info';
    my $snp_result = 'ar_snp_result';
    my $insert_result;

    my $tx = $db->begin;

    my @item_cols = qw/条形码 姓名 性别 年龄 联系方式 送检单位 检测项目 接样日期/;
    my $item;
    map { $item->{$_} = $hashref->{$_} } @item_cols;
    $insert_result = $db->insert($item_info, $item, { returning => 'id' });

    my $last_insert_id = $insert_result->hash->{id};
    my $snp_re = qr/^rs/;    # 匹配位点的规则，目前为rsid
    foreach my $key (grep /$snp_re/, keys %$hashref){
	$db->insert($snp_result, {
			'样本' => $last_insert_id,
			'位点' => $key,
			'碱基' => $hashref->{$key},
		    });
    }

    $tx->commit;

    return $@ ? [ $hashref->{'条形码'} => 0 ] : [ $hashref->{'条形码'} => 1 ];  # 如果插入正确返回条码
}

sub listItem {
    my $self = shift;

    # pg->db->select($table, $fields, $where, \%options)
    my $list = $self->pg->db->select($self->item_tbl, '*', undef, { order_by => { -desc => 'id' } })->hashes->to_array;

    return $list if @{$list};
    return undef;
}

sub fetchItem {
    my $self = shift;
    my ($pcode, $sampleid) = @_;

    my $item = $self->pg->db->select(
        $self->item_tbl, '*', {'条形码' => $sampleid, '检测项目' => $pcode}
    )->hash;
    my $snps = $self->pg->db->select(
        $self->snp_tbl, ['位点', '碱基'],{'样本' => $item->{id}}
    )->arrays->flatten->to_array;

    return +{ %$item, @$snps };
}

1;
