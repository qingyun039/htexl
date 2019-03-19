% zpgene.cls
% 中平的基因检测报告
% 2019-03-14 Qingyun039

% --- Class structure: identification part
% ---
\ProvidesClass{zpgene}[2019/03/14 v1.00 no thing]
\NeedTeXFormat{LaTeX2e}


% --- Class structure: declaration of options
% ---
% 使用ctexbook文档类, 对应的参数传到该类
\DeclareOption*{\PassOptionsToClass{CurrentOption}{ctexbook}}

% --- Class structure: excution of options
% ---
\ProcessOptions\relax

% --- Class structure: package loading
% ---
\LoadClass{ctexbook}

% Page Layout
\RequirePackage[paperwidth=8.27in,paperheight=11.22in, margin=25mm, includehead, includefoot]{geometry}

% Headers and Footers
\RequirePackage{fancyhdr}
\fancypagestyle{firstpage}{%
	\fancyhf{}
	\renewcommand{\headrule}{0pt}
	\renewcommand{\footrule}{0pt}
}
\fancypagestyle{zpgene}{%
	\fancyhf{}
	\fancyhead[OL]{\includegraphics[scale=1]{zpgaghdr.eps}}   % ???图片
	\fancyhead[ER]{\includegraphics[scale=1]{header1.eps}}    % ???图片
	\fancyfoot[OL,RE]{\color{black!60}\sffamily 【\quad\thepage\quad{}】}  % ???字体
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\footrulewidth}{0pt}
}
\pagestyle{zpgene}
AtBeginDocument{\thispagestyle{firstpage}}

