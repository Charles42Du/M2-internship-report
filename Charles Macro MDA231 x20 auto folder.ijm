run("Close All");
run("Clear Results");
close("*");


#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".jpg") suffix


processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}


function processFile(input, output, file) {
	run("Close All");
	
	run("Clear Results");
	
	close("*");
	
	open(input + File.separator + file);
	
	currentImage_name=getTitle();
	
	run("Cellpose Advanced (custom model)", "diameter=71 cellproba_threshold=0.0 flow_threshold=0.4 anisotropy=1.0 diam_threshold=12.0 model_path=[C:\\Users\\charles.du\\.cellpose\\models\\MDA X20 v2.6] model=[C:\\Users\\charles.du\\.cellpose\\models\\MDA X20 v2.6] nuclei_channel=0 cyto_channel=0 dimensionmode=2D stitch_threshold=-1.0 omni=false cluster=false additional_flags=");
	
	run("Set Scale...", "distance=2.24 known=1 unit=micron global");

	run("glasbey on dark");
		
	run("Label image to ROIs", "rm=[RoiManager[visible=true]]");
	
	roiManager("Show All without labels");
	
	roiManager("Measure");
	
	height=Table.getColumn("Height");
	width=Table.getColumn("Width");
	feretwidth=Table.getColumn("MinFeret");
	feretheight=Table.getColumn("Feret");
	
	for (i = 0; i < nResults; i++) {
	
	   ratio = width[i] / height[i];
	    
	    setResult("SI", i, ratio);
	    
	   ratio1 = height[i] / width[i];
	    
	    setResult("SI1", i, ratio1);
	   
	   ratio2 = feretheight[i] / feretwidth [i];
	   
	    setResult("TrueSI", i, ratio2);
	}
	
	Table.sort("Area");

		
	saveAs("Results", output + File.separator + currentImage_name + "_.csv");
	roiManager("Save", output + File.separator + currentImage_name + "_.zip");
	
	run("Close All");
	
	run("Clear Results");
	
	close("*");
}