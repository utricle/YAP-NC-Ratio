//Open image of SC nuclei with Actin, Myo7a, YAP, Hoechst channels in that order

//Specify measurements 
	run("Set Measurements...", "mean redirect=None decimal=3");

//Rename image and split channels
	rename("img");
	run("Split Channels");

//Create preliminary cytoplasm mask
	selectWindow("C1-img");
	run("OtsuThresholding 16Bit");

//create nuclei mask
	run("Create Mask");
	run("Duplicate...", "title=Nuclei");
//selectWindow("Nuclei");
//create nuclei mask
selectWindow("mask");
run("Invert");
//selectWindow("mask");
rename("Cytoplasm");
//create myo7a mask
selectWindow("C2-img");
run("OtsuThresholding 16Bit");
setOption("BlackBackground", true);
//reduce background noise of myo7a mask, rename as myo7a
	run("Create Mask");
	run("Erode");
	run("Dilate");
	selectWindow("mask");
	rename("Myo7A");

//subtract Myo7a from cytoplasm mask
	imageCalculator("Subtract create", "Cytoplasm", "Myo7A");
	selectWindow("Result of Cytoplasm");
	rename("Cytoplasm");

//create ROI overlay of Cytoplasm onto YAP channel
	run("Create Selection");
	roiManager("Add");
	roiManager("Select", 0); //0 = first on ROI manager list
	roiManager("Rename", "Cytoplasm");

//create ROI overlay of Nuclei onto YAP channel
	selectWindow("Nuclei");
	run("Create Selection");
	roiManager("Add");
	roiManager("Select", 1); //1=second on list
	roiManager("Rename", "True Nuclei");
	selectWindow("Myo7A");

//create ROI overlay of Myo7a onto YAP channel
	run("Create Selection");
	roiManager("Add");
	roiManager("Select", 2); //2 = third on list
	roiManager("Rename", "Myo7A");
	selectWindow("C3-img");
	roiManager("Show All");

//close other windows to avoid interference
	//selctWindow("True Nuclei");
		//close();
	//selctWindow("Myo7A");
		//close();
	//selctWindow("Nuclei");
		//close();
	//selctWindow("Cytoplasm");
		//close();
	//selctWindow("C4-img");
		//close();

//Multimeasure to obtain data
	selectWindow("C3-img");
	roiManager("Select", newArray(0,1,2));
	roiManager("Multi Measure");
	String.copyResults();

//Clear ROIs and delete open windows (results still copied to clipboard)
	Table.deleteRows(0, 0);
	roiManager("Deselect");
	roiManager("Delete");
	close();
	close();
	close();
	close();
	close();
	close();
	close();
	selectWindow("C4-img");
	close();