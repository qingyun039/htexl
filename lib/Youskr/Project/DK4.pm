package Youskr::Project::DK4;
use Mojo::Base 'Youskr::Project';

use DBM::Deep;
use Mojo::Cache;
use Carp qw/carp croak/;

has name => '儿童安全用药';

has RELATION => sub { DBM::Deep->new('/proj/auto_rep/lib/AutoRep/Project/DRG/DRG.db') };

has cache => sub { Mojo::Cache->new };

sub _have{
	return +[qw/rs9332239	rs12422149	rs1042713	rs1876828	rs8099917	rs20417	rs1050828	rs1065852	rs4986893	rs4244285	rs12979860	rs2306168	rs12746200	rs1057910	rs1799853	rs267606617	rs267606619/];
}

sub _data{
	my $self = shift;
	my $data;
	my %hash;
	foreach my $drug (@{$self->RELATION->{drugs}}){
		my $name = $drug->[0].($drug->[1]?'('.$drug->[1].')':'');
		push @{$data->{drugs}{$drug->[4]}}, [$name, $drug->[3], $self->_drug($drug->[0])];
		push @{$hash{$drug->[5]}}, $name;
	}

	foreach my $component (@{$self->RELATION->{components}{desc}}){
		my $drug_name = join "，", @{$hash{$component->[0]}};
		my $genes = $self->_component($component->[0]);
		my @genes;
		foreach my $g (keys %$genes){
		    foreach my $r (keys %{$genes->{$g}}){
				my $result = $genes->{$g}->{$r}->[1];
				my $desc = $genes->{$g}->{$r}->[0];
				push @genes, [$g, $r, $self->{$r}, $result, $desc]
		    }
		}
		push @{$data->{components}}, {
			component => $component->[0],
			class     => $component->[1],
			description => $component->[2],
			reference => $component->[3],
			genes => [@genes],
			drug => [@{$hash{$component->[0]}}]
		};
	}

	# 药物性耳聋
	my $result = ($self->{rs267606619} eq 'CC' and $self->{rs267606617} eq 'AA') ? '正常' : '高风险';
	my @deaf_drugs = ("卡那霉素", "妥布霉素(抗普霉素)", "大观霉素", "新霉素", "庆大霉素", "威地霉素", "西索米星(紫苏霉素、西索霉素)", "小诺霉素", "阿米卡星(丁胺卡那霉素)", "奈替米星(奈特、力确兴、诺达)", "核糖霉素", "爱大(硫酸依替米星)", "依克沙(硫酸异帕米星)", "小儿利宝");
	foreach my $drug (@deaf_drugs){
		push @{$data->{drugs}{'药物性耳聋'}}, [$drug, '-', '谨遵医嘱', $result];
		push @{$hash{'药物性耳聋'}}, $drug;
	}
	push @{$data->{components}}, {
		component => '药物性耳聋',
		class => '药物性耳聋',
		description => '氨基糖苷类，还有阿米卡星等半合成氨基糖苷类。氨基糖苷类抗生素如庆大霉素、链
霉素和托普霉素等都是在临床上非常重要的药物，而这些药物的使用常常会导致部分病人听力不可逆的损
伤，在耳聋病人中，有很高比例是由于氨基糖苷类抗生素的耳毒性引起的，在家族性的药物损伤性耳聋中，
氨基糖苷类抗生素耳毒性的高度敏感通常为母系遗传，研究发现在线粒体
12S rRNA
上发现了多个和严重
的药物性耳聋相关的基因突变，其中尤以
rs267606619
和
rs267606617
突变在氨基糖苷类抗生素引发的耳
聋病例中占有显著的比重。其中线粒体
rs267606619
和
rs267606617
突变携带率约为
1/300
，听力正常的
育龄夫妇携带至少一种基因突变的几率为
6.3%。',
		genes => [
			['MT-ND1', 'rs267606619', $self->{'rs267606619'}, ($self->{rs267606619} eq 'CC' ? ('正常','受检者 rs267606619 位点没有发生突变。') : ('高风险', '受检者 rs267606619 位点发生了突变。'))],
			['MT-ND1', 'rs267606617', $self->{'rs267606617'}, ($self->{rs267606617} eq 'AA' ? ('正常','受检者 rs267606617 位点没有发生突变。') : ('高风险', '受检者 rs267606617 位点发生了突变。'))],
		],
		drug => [@{$hash{'药物性耳聋'}}]
	};
	return $data;
}


sub _component {
    my ($self, $component) = @_;
    my $rc;

    return $rc if $rc = $self->cache->get($component);

    my $e = [ 'xxxxxxxxxxxxxx','-' ];

    (my $component_has_gene = $self->RELATION->{components}{gene}{$component}) or carp "没有药品成分信息:$component";
    (my $component_detect_regulation = $self->RELATION->{result}{$component}) or carp "没有药品成分判断规则:$component";
    (my $nuc_to_hypo = $self->RELATION->{gene_rs}) or carp "ERROR";
    
    foreach my $gene (keys %$component_has_gene){
	foreach my $rs (@{$component_has_gene->{$gene}}){
	    carp "检测数据中没有位点：".$rs unless $self->{$rs};
	    my @hypos = map { $nuc_to_hypo->{$gene}{$rs}{$_}[0] || () } (split //, $self->{$rs}); # 前面验证rs存在
	    carp "检测到的碱基值没有对应的亚型:$component-$gene-".$self->{$rs} and next if @hypos != 2;
	    $rc->{$gene}{$rs} = $component_detect_regulation->{$gene}{join '_', @hypos} || $e;
	    carp "没有对应的规则: $component-$gene-@hypos" and next unless $rc->{$gene}{$rs};
	}
    }
    foreach my $gene (keys %$rc){
	if($gene eq 'CYP2C19'){
	    if(
	    $rc->{$gene}{'rs4244285'}[0] =~ /CYP2C19\*1和CYP2C19\*1/ 
		and 
	    $rc->{$gene}{'rs4986893'}[0] !~ /CYP2C19\*3和CYP2C19\*3/){
		$rc->{$gene}{'rs4986893'} = $rc->{$gene}{'rs4244285'};
	    }
	    elsif( 
	    $rc->{$gene}{'rs4986893'}[0] =~ /CYP2C19\*1和CYP2C19\*1/
		and
	    $rc->{$gene}{'rs4244285'}[0] !~ /CYP2C19\*3和CYP2C19\*3/){
		$rc->{$gene}{'rs4244285'} = $rc->{$gene}{'rs4986893'};
	    }
	    elsif(
	    $rc->{$gene}{'rs4244285'}[0] =~ /CYP2C19\*2和CYP2C19\*2/){
		$rc->{$gene}{'rs4986893'} = $rc->{$gene}{'rs4244285'};
	    }
	    elsif(
	    $rc->{$gene}{'rs4986893'}[0] =~ /CYP2C19\*3和CYP2C19\*3/){
		$rc->{$gene}{'rs4244285'} = $rc->{$gene}{'rs4986893'};
	    }else{
		$rc->{$gene}{'rs4986893'} = $rc->{$gene}{'rs4244285'};
	    }

	}
    }
    $self->cache->set($component => $rc);
    return $rc;
}

sub _drug {
    my ($self, $drug) = @_;

    my $drug_index = $self->RELATION->{map}->{$drug};
    my $component_result = $self->_component($self->RELATION->{drugs}[$drug_index][5]);
    my @only_result;
    foreach my $g (keys %$component_result){
	foreach my $r (keys %{$component_result->{$g}}){
	    push @only_result, [ $component_result->{$g}->{$r}->[1], $component_result->{$g}->{$r}->[2] ];
	}
    }

    my @warn = grep { $_->[0] =~ /谨遵/ } @only_result;
    my @info = grep { $_->[0] =~ /正常/ }  @only_result;

    if(@only_result == @info){
	return ('正常服用', $info[0]->[1]);
    }
    $warn[0]->[0] =~ s/\*+//g;
    return ($warn[0]->[0], $warn[0]->[1]);
}

1;