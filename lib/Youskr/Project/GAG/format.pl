#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Storable;
use Data::Dumper;

my $hash = [
	{'音乐' => {  # 音乐
	    PCDH7 => { rs13146789 => { GG => 87, GT => 75, TT => 67 }},
	    GATA2 => { rs9854612  => { AA => 85, AG => 71, GG => 65 }},
	}},
	{'舞蹈' => { # 舞蹈
		ACTN3 => { rs1815739  => { CC => 92, CT => 80, TT => 68 }},
		SLC6A4 => { rs25531 => { TT => 64, TC => 72, CC => 84 }},
	}},
	{'语言' => {
		 FOXP2 => { rs1852469 => { TT => 87, AT => 76, AA => 67 } } 
	}}, 
	{'专注力' => {
		 CLOCK => { rs1801260 => { GG => 86, AG => 76, AA => 68 }}
	}},
	{'记忆力' => { # 记忆
	    BNDF => { rs6265 => { CC => 88, CT => 78, TT => 68 }},
		KIBRA => { rs17070145 => { CC => 93, CT => 80, TT => 70 }},
		COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	}},
	{'运动' => { # 运动
	    ADRB3 => { rs4994 => { GG => 84, GA => 78, AA => 69 }},
		ACTN3 => { rs1815739  => { CC => 92, CT => 80, TT => 68 }},
	    PPARGC1A => { rs8192678 => { CC => 87, TC => 81, TT => 63 }},
	}},
	{'好奇心' => { # 好奇心
	    DRD4 => { rs1800955 => { CC => 88, CT => 80, TT => 67 }},
	}},
	{'认知能力' => {  # 认知能力
	    KIBRA => { rs17070145 => { CC => 93, CT => 80, TT => 70 }},
	    ANKK1 => { rs1800497 => { GG => 83, GA => 71, AA => 65 }}, 
	    SNAP25 => { rs363050 => { AA => 92, AG => 79, GG => 67 }}, 
		COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	    BDNF => { rs6265 => { CC => 88, CT => 78, TT => 68 }},
	}},
	{'应变能力' => { # 应变能力
	    COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	}},
	{'数学' => { # 数学
		 BDNF  => { rs6265    => { CC => 88, CT => 78, TT => 68 } } 
	}}, 
	{'乳糖不耐受' => { # 乳糖
		MCM6 => { rs4988235 => { GG => '不耐受', AG => '耐受       ', AA => '耐受       ' }},
	}}, 
	{'近视' => { # 近视
	    LRRC4C => { rs1381566 => { GG => '高风险      ', GT => '中风险   ', TT => '低风险' }},
	}},
#	{'牙齿' => { # 牙发育
#	    HMGA2 => { rs17179670 => { AA => '正常数量                   ', AG => '比一般数量少1个', GG => '少1到2个' }},
#	}},
	{'肥胖' => { # 肥胖
		FTO => { rs6232 => { CC => '高水平      ', CT => '平均水平  ', TT => '低水平' }},
	}},
	{'易多动' => { # 多动
		DRD2 => { rs1800497 => { AA => '高风险      ', AG => '中风险   ', GG => '低风险' }},
	}},
	{'身高' => { # 身高
	    HMGA2 => { rs1042725 => { CC => '高水平      ', CT => '平均水平  ', TT => '低水平' }},
	}},
	{'骨密度' => { # 骨密度
	    VDR => { rs1544410 => { CC => '优秀       ', CT => '良好    ', TT => '一般 ' }},
	}}
];

print Dumper($hash);
store $hash, 'GAG.Pdata';
