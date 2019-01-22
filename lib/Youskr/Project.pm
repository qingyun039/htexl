##########################################
# 模块名：Youskr::Project
# 版本：0.1.0
# 作者：qingyun039
# 描述：项目基类
#       
#
# 修改：0
# 修改：1
#       改用 Template Toolkit 作为模板引擎
# 修改：2
#       Project 只用与产生数据，不用于渲染，相当于Model
# #########################################

package Youskr::Project;
use Mojo::Base -base;

use Data::Dumper;
use Smart::Match qw/contains/;
use Mojo::Log;

=attr 错误记录对象

Mojo::Log 对象, 用于打印错误

=cut

has log => sub{ Mojo::Log->new };

=method _have

该项目必须有的项, 比如rsid

=cut

sub _have{
    die "must subclass";
}

sub _data{
    die "must _data subclass";
}

sub validate{   # 在子类中实现吧
    my ($self, $pcode) = @_; # $pcode 用于一些项目中有检测单项和多项的

    my $item = {%$self};
    my @l1 = keys %$item;
    my @l2 = @{$self->_have};

    return  @l1 ~~ contains(@l2) ? 1 : 0;
}

sub stash {
    my $self = shift;
  
    return +{
        item => {map {($_, $self->{$_})} grep { ! $self->can($_)} keys %$self},
        result => $self->_data,
    };
}

1;


=head 说明

一般而言, 
1. 在构建Project对像时传入的参数为基本参数, 既应该为检测结果表中的信息, 如:
条形码, 
姓名, 
送检单位,
及各位点的检测值

这些都是关乎报告的内容.

2. 在宣染时提供的参数, 既调用方法render时的参数, 是关乎报告的样式(呈现), 如:
使用的模板,
logo,
页面布局相关

3. 参数并不会强制以上要求, 但是遵守利于逻辑清晰
