package Htexl::Model::Common;
use Mojo::Base -strict;

use List::MoreUtils qw/pairwise/;
use Spreadsheet::Read qw/ReadData rows/;
use Mojo::Collection qw/c/;

use POSIX qw(strftime);
use Exporter 'import';

our @EXPORT_OK = qw/
	currentDate normalizeDate
	sheet2collection
/;


# 输出当前日期: 2018-12-19
sub currentDate {
	return strftime("%F", localtime);
}

# 将xls中的时间格式转换成标准的时间格式: 181219 -> 2018-12-19
sub normalizeDate {
	my $date = shift;
	if($date =~ /(\d{4})(\d{2})(\d{2})/){
		return "$1-$2-$3";
	}
	return currentDate();
}

# 函数名: sheet2cellection
# 描述：将表格文件转化成Mojo::Collection对象。
#       支持的文件格式为：xls，xlsx，csv
#       可指定是否有表头，转化指定的sheet
sub sheet2collection{
    my ($file, $ishead, @include) = @_;
    $ishead ||= 1;
    my @rc = ();

    my $book = ReadData($file);
    @include = (1 .. $book->[0]{sheets}) unless @include;
    foreach my $i (@include){
        my $collection = c( rows($book->[$i]) )->map(sub{ [ @$_, $file ] });
        if($ishead){
            my $head = $collection->first;
	    $head->[-1] = 'from';
            $collection = $collection
                ->slice( 1 .. $collection->size - 1)
                ->map(sub{ my $hashref = { pairwise { ($a => $b) } @{$head}, @{$_}}; $hashref})   # 有更风骚的不用中间变量$hashref的写法吗？
        }
        push @rc, $collection;
    }

    return wantarray ? (@rc) : shift @rc;
}

1;
