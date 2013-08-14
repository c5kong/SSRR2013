function X = automate()
	tic
	%-- 2011 Disaster City --%
	directory = ('images/2011DC-2/');
	segmentation('69_d.png', directory);
	segmentation('463_d.png', directory);
	segmentation('770_d.png', directory);
	segmentation('780_d.png', directory);
	segmentation('1815_d.png', directory);
	segmentation('1953_d.png', directory);
	segmentation('2223_d.png', directory);
	segmentation('2430_d.png', directory);
	segmentation('2440_d.png', directory);
	segmentation('2450_d.png', directory);
	segmentation('2490_d.png', directory);
	segmentation('2550_d.png', directory);
	segmentation('2580_d.png', directory);
	segmentation('2700_d.png', directory);
	segmentation('3160_d.png', directory);
	segmentation('3170_d.png', directory);
	segmentation('3190_d.png', directory);
	segmentation('3200_d.png', directory);
	segmentation('3220_d.png', directory);
	segmentation('3240_d.png', directory);
	segmentation('3250_d.png', directory);
	segmentation('3280_d.png', directory);
	segmentation('3320_d.png', directory);
	segmentation('3648_d.png', directory);
	segmentation('3800_d.png', directory);
	segmentation('3918_d.png', directory);
	segmentation('3932_d.png', directory);
	segmentation('4100_d.png', directory);
	segmentation('4600_d.png', directory);
	segmentation('4832_d.png', directory);
	segmentation('5198_d.png', directory);
	segmentation('5800_d.png', directory);

	%-- 2012 UCRT 1 --%
	directory = ('images/2012UCRT-1/');
	segmentation('1400_d.png', directory);
	segmentation('2000_d.png', directory);
	segmentation('5200_d.png', directory);

	%-- 2012 UCRT 2 --%
	directory = ('images/2012UCRT-2/');
	segmentation('700_d.png', directory);
	segmentation('1300_d.png', directory);
	segmentation('2100_d.png', directory);
	segmentation('2200_d.png', directory);

	%-- 2012 UCRT 3 --%
	directory = ('images/2012UCRT-3/');
	segmentation('3000_d.png', directory);
	segmentation('3027_d.png', directory);
	segmentation('3114_d.png', directory);
	segmentation('6400_d.png', directory);
	segmentation('6800_d.png', directory);
	segmentation('7000_d.png', directory);
	segmentation('7019_d.png', directory);
	segmentation('7029_d.png', directory);
	segmentation('7057_d.png', directory);
	segmentation('7075_d.png', directory);
	toc
end