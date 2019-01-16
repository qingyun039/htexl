##########################################
# 模块名：
# 版本：0.1.0
# 作者：qingyun039
# 描述：
#       
#
# 修改：0
# #########################################
package Youskr::Project::JTK02;
use Mojo::Base 'Youskr::Project';

has name =>'儿童天赋30项基因检测报告';

sub _have{
    return [qw/
    		rs1042725
			rs1079572
			rs13146789
			rs1381566
			rs1544410
			rs17070145
			rs17179670
			rs17608059
			rs1800169
			rs1800497
			rs1800955
			rs1815739
			rs2143340
			rs25531
			rs363050
			rs3743205
			rs4680
			rs4950
			rs4988235
			rs61734651
			rs6232
			rs6265
			rs909525
			rs9854612
			/
			];
}

sub _data{
	my $self = shift;

	my %relation = %{$self->RELATION};
	my $data;
	foreach my $gift (keys %relation){
		foreach my $gene (keys %{$relation{$gift}}){
			foreach my $rsid (keys %{$relation{$gift}{$gene}}){
				my %criteria = %{$relation{$gift}{$gene}{$rsid}};
				my $genotype = $self->{$rsid};
				die "$rsid dont exist: $rsid" unless $genotype;
				my $genotype_rev = join '', (split //, $self->{$rsid})[1,0];

				my ($risk, @genotypes);
				# 天赋的检测分值
				$risk = $criteria{$genotype} || $criteria{$genotype_rev};
				if($risk =~ /^\d+$/){
					$data->{$gift}{risk} += $risk;
					@genotypes = sort { $criteria{$a} <=> $criteria{$b} } keys %criteria;
				}else{
					$data->{$gift}{risk} = $risk;
					@genotypes = sort { length $criteria{$a} <=> length $criteria{$b} } keys %criteria;
				}

				# 表格数据
				push @{$data->{$gift}{genes}}, [$gene, $rsid, @genotypes];
			}
		}
	}

	return $data;
}

sub RELATION  {
    return +{
#	LANG => { FOXP2 => { rs1852469 => { TT => 87, AT => 76, AA => 67 } } }, 
	MATH => { BDNF  => { rs6265    => { CC => 88, CT => 78, TT => 68 } } },  #---------------
	IQ   => { # 智商 -------------------
#	    COMT => { rs4680 => { AA => 85, AG => 73, GG => 63 }},
#	    SNAP25 => { rs363050 => { AA => 85, AG => 75, GG => 67 }},
	    SNAP25 => { rs363050 => { AA => 92, AG => 79, GG => 67 }}, 
	    COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	},
	REMEM => { # 记忆 ---------------------
	    BNDF => { rs6265 => { CC => 88, CT => 78, TT => 68 }},
#	    KIBRA => { rs17070145 => { CC => 84, CT => 72, TT => 70 }},
		KIBRA => { rs17070145 => { CC => 93, CT => 80, TT => 70 }},
#	    COMT => { rs4680 => { AA => 86, AG => 74, GG => 64 }},
		COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	},
#	CONCE => { CLOCK => { rs1801260 => { GG => 86, AG => 76, AA => 68 }}},
#	CREAT => { DRD4  => { rs1800955 => { CC => 88, CT => 80, TT => 67 }}},
	MUSIC => {  # 音乐 ---------------
	    PCDH7 => { rs13146789 => { GG => 87, GT => 75, TT => 67 }},
	    GATA2 => { rs9854612  => { AA => 85, AG => 71, GG => 65 }},
	},
	DANCE => { # 舞蹈 ----------------
#	    ACTN3 => { rs1815739  => { CC => 86, CT => 74, TT => 68 }},
		ACTN3 => { rs1815739  => { CC => 92, CT => 80, TT => 68 }},
#	    SLC6A4 => { rs25531   => { TT => 84, TC => 72, CC => 64 }},
		SLC6A4 => { rs25531 => { TT => 64, TC => 72, CC => 84 }},
	},
	PANIT => { # 绘画 -------------------
	    BDNF => { rs6265 => { CC => 88, CT => 78, TT => 68 }},
#	    ANKK1 => { rs1800497 => { GG => 82, GA => 70, AA => 64 }}, 
	    ANKK1 => { rs1800497 => { GG => 83, GA => 71, AA => 65 }}, 
#	    COMT => { rs4680 => { AA => 85, AG => 73, GG => 63 }},
		COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	},
#	SPORT => {
#	    ADRB3 => { rs4994 => { GG => 84, GA => 78, AA => 69 }},
##	    ACTN3 => { rs1815739 => { CC => 91, CT => 75, TT => 66 }},
#		ACTN3 => { rs1815739  => { CC => 92, CT => 80, TT => 68 }},
#	    PPARGC1A => { rs8192678 => { CC => 87, TC => 81, TT => 63 }},
#	},
	READ => { # 阅读能力 ---------------
#	    DYX1C1 => { rs3743205 => { CC => 81, CT => 71, TT => 67 }},
#	    COMT   => { rs4680    => { AA => 85, AG => 73, GG => 63 }},
	    DYX1C1 => { rs3743205 => { CC => 88, CT => 74, TT => 67 }},
	    COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	},
	COGNIZE => {  # 认知能力 -----------------
#	    KIBRA => { rs17070145 => { CC => 84, CT => 72, TT => 70 }},
	    KIBRA => { rs17070145 => { CC => 93, CT => 80, TT => 70 }},
#	    ANKK1 => { rs1800497 => { GG => 82, GA => 70, AA => 64 }}, 
	    ANKK1 => { rs1800497 => { GG => 83, GA => 71, AA => 65 }}, 
#	    SNAP25 => { rs363050 => { AA => 85, AG => 75, GG => 67 }}, 
	    SNAP25 => { rs363050 => { AA => 92, AG => 79, GG => 67 }}, 
#	    COMT => { rs4680 => { AA => 85, AG => 73, GG => 63 }},
		COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	    BDNF => { rs6265 => { CC => 88, CT => 78, TT => 68 }},
	},
#	ERR => {  # 避免重复犯错能力
#	    ANKK1 => { rs1800497 => { GG => 83, GA => 71, AA => 65 }},
#	},
	SPACE => { # 空间想象力 -----------------
#	    KIBRA => { rs17070145 => { CC => 84, CT => 72, TT => 70 }},
		KIBRA => { rs17070145 => { CC => 93, CT => 80, TT => 70 }},
	    BDNF => { rs6265 => { CC => 88, CT => 78, TT => 68 }},
	},
	BACKWARD => {  # 逆向思维能力 ---------------
	    ANKK1 => { rs1800497 => { GG => 83, GA => 71, AA => 65 }},
	},
	CURIOUS => { # 好奇心 ------------------
	    DRD4 => { rs1800955 => { CC => 88, CT => 80, TT => 67 }},
	},
	FINANCE => { # 理财能力 -----------------
#	    COMT => { rs4680 => { AA => 85, AG => 73, GG => 63 }},
	    COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	}, 
	LEAD => { # 领导能力 --------------------
	    CHRNB3 => { rs4950 => { GG => 85, AG => 72, AA => 62 }},
	},
	WILL => { # 毅力 -----------------
	    COX10 => { rs17608059 => { CC => 85, CT => 75, TT => 65 }},
	},
	ADVENTURE => { # 冒险意识 ----------------
	    DRD4 => { rs1800955 => { CC => 88, CT => 80, TT => 67 }},
	},
	STRAIN => { # 应变能力 ----------------
#	    COMT => { rs4680 => { AA => 85, AG => 73, GG => 63 }},
	    COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	},
	INDEPADENT => { # 独立性 -----------------
#	    SLC6A4 => { rs25531 => { TT => 84, TC => 72, CC => 64 }},
		SLC6A4 => { rs25531 => { TT => 64, TC => 72, CC => 84 }},
#	    COMT => { rs4680 => { AA => 85, AG => 73, GG => 63 }},
	    COMT   => { rs4680    => { AA => 63, AG => 73, GG => 85 }},
	},
	FRIENDLY => { # 友善度 -------------------
	    MAOA => { rs909525 => { TT => 84, TC => 74, CC => 64 }},
	}, 
	SPEECH => { # 演讲表达能力 -----------------
#	    TTRAP => { rs2143340 => { AA => 83, AG => 73, GG => 65 }},
		TTRAP => { rs2143340 => { AA => 85, AG => 75, GG => 65 }},
#	    SNAP25 => { rs363050 => { AA => 85, AG => 75, GG => 67 }},
		SNAP25 => { rs363050 => { AA => 92, AG => 79, GG => 67 }}, 
	},
	HANDLE => { # 动手能力 ---------------------
#	    SNAP25 => { rs363050 => { AA => 85, AG => 75, GG => 67 }},
	    SNAP25 => { rs363050 => { AA => 92, AG => 79, GG => 67 }}, 
	},
	# 满脑子都是骚操作T-T
	HEIGHT => { # 身高 --------------------
	    HMGA2 => { rs1042725 => { CC => '高水平       ', CT => '平均水平', TT => '低水平' }},
	},
	SHORTSIGHT => { # 近视 -----------------
	    LRRC4C => { rs1381566 => { GG => '高风险      ', GT => '中风险', TT => '低风险' }},
	}, 
	THOOTH => { # 牙发育 ------------------
	    HMGA2 => { rs17179670 => { AA => '正常数量                   ', AG => '比一般数量少1个', GG => '少1到2个' }},
	},
	MILK => { # 牛奶吸收能力 -----------------
	    MCM6 => { rs4988235 => { AA => '优秀  ', AG => '良好 ', GG => '一般' }},
	},
	WEIGHT => { # 体重 -----------------
	    FTO => { rs6232 => { CC => '高水平         ', CT => '平均水平', TT => '低水平' }},
	},
	LUNG => { # 肺活量 ------------------
	    WWOX => { rs1079572 => { GG => '优秀  ', GA => '良好 ', AA => '一般' }},
	},
	BONE => { # 骨密度 ------------------
	    VDR => { rs1544410 => { CC => '优秀  ', CT => '良好 ', TT => '一般' }},
	},
	MUSCLE => { # 肌肉力量 -------------------
	    CNTF => { rs1800169 => { AA => '优秀  ', AG => '良好 ', GG => '一般' }},
	},
	BURST => { # 爆发性 --------------
	    ACTN3 => { rs1815739 => { CC => '优秀  ', CT => '良好 ', TT => '一般' }},
	},
	FLEX => { # 身体柔韧性 ---------------
	    COL9A3 => { rs61734651 => { CC => '优秀  ', CT => '良好 ', TT => '一般' }},
	},
    };
}


1;
