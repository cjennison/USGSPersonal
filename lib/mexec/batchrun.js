/**
 * New node file use spawn to test
 */
var fs = require('fs');
var spawn = require('child_process').spawn;

var getPath = function(user,model, runId){
	return './'+user+'/'+model+'/'+runId;
};


var buildScriptPara = function (run) {
	var paras;

	for (var prerun in run['pre_runs']) {
		path = getPath(prerun.user,prerun.scriptName,prerun.runId);
		fs.readFile(path);
	}

	if(run['input'] !== null){
		for(var p in run['para']){
			console.log(run['input']);
			if(run['input'][p] !== null)
				paras[p]=run['input'][p];
		}
	}
	return paras;
};

function mkdir_p(dirPath, mode, callback) {
  //Call the standard fs.mkdir
  require('fs').mkdir(dirPath, mode, function(error) {
    //When it fail in this way, do the custom steps
    if (error && error.errno === 34) {
      //Create all the parents recursively
      mkdir_p(require('path').dirname(dirPath), mode, callback);
      //And then the directory
      mkdir_p(dirPath, mode, callback);
    }
    //Manually run the callback since we used our own callback to do all these
    callback && callback(error);
  });
}

/*
function mkdir_p(path, mode, callback, position) {
    mode = mode || 511; // 777 in octal
    position = position || 0;
    var parts = require('path').normalize(path).split('/');
 
    if (position >= parts.length) {
        if (callback) {
            return callback();
        } else {
            return true;
        }
    }
 
    var directory = parts.slice(0, position + 1).join('/');

    fs.stat(directory, function(err) {
        if (err === null) {
            mkdir_p(path, mode, callback, position + 1);
        } else {
            fs.mkdir(directory, mode, function (err) {
                if (err) {
                    if (callback) {
                        return callback(err);
                    } else {
                        throw err;
                    }
                } else {
                    mkdir_p(path, mode, callback, position + 1);
                }
            });
        }
    });
}
*/
var getArgs = function(paras){
	var agrs=[];
	for(var p in paras){
		args.push(p);
	}
	return args;
};
/*
var outputfile = function(Rrun, data){
	path = getPath(Rrun['user'],Rrun['scriptName'],Rrun['runId']);
	
	fs.exists(path,function(exists){
      if(!exists)	{
        mkdir_p(path);
      }
    });
    var regex = /\w+/g;
	newdata = data.match(regex).toString();
	regex = /\[[^\]]+\]/g;
	newdata.replace(regex,"");
	fs.writeFile(path, newdata, function(err){
		if (err) throw err;
    console.log(Rrun['runId']+' is saved!');
	});
};
*/
var runModels = function(runs,idx,modelpath) {
	Rrun = runs[idx];
	
	//set up directory for this runs
	path = getPath(Rrun['user'],Rrun['scriptName'],Rrun['runId']);
	fs.exists(path,function(exists){
      if(!exists)	{
		//console.log(path);
        mkdir_p(path);
    }
  });

	//prepare for spawn arguments
	RArgs =[Rrun['scriptName']+'.R'];
	var paras =JSON.stringify(Rrun);
	RArgs = RArgs.concat(paras);
	spawnOpt = {
		cwd:  modelpath,
		env: process.env
	};
	var ls = spawn('Rscript',RArgs,spawnOpt);
	ls['data']=Rrun['user']+' '+Rrun['runId']+' '+Rrun['scriptName'];
	/*
	assume we have let r finish running and we know the output directory
	var output ={
			user: string
			runId: num or string
			scriptName: string
			parameter:{} // object
		}
	*/

	ls.stdout.on('data', function (data) {
		ls['data'] = data.toString();
		console.log('stdout : ' + ls['data']);
	});

	ls.stdout.on('end', function(data){
		//console.log('stdEnd : ' + ls['data']);
		
	});

	ls.stderr.on('data', function (data) {
    	console.log('stderr: ' + data);
	});

	ls.on('exit', function (code) {
    //console.log('child process exited with code ' + code);
    console.log(Rrun['runId']+' complete');
    //outputfile(Rrun,ls['data'])
    idx++;
    if(idx<runs.length){
      runModels(runs,idx,modelpath);
    }
	});
};

var buildRuns = function(reqbody){
	var runs = [];
	var run1 = {
		user: reqbody.user,
		runId: reqbody.runId,
		scriptName: reqbody.scriptName
	};
	runs.push(run1);
	
	return runs;
}


 //data structure for run Object
// var 	Rrun1={
// 			user: 'kun',
// 			runId: 1,
// 			scriptName: 'testR',
// 			//para:['TEST', 'the', 'arguments'],	//given in database
// 			//input:{TEST:1, the: null,arguments:null}, // 11/29/2012: input should be a JSON Object
// 			pre_runs:[],	//11/29/2012: required_runs is an array of run_Objects
// 			outputs:['output1_name','output2_name'],	//given in database
// 			count:3
// 		}		
// var Rrun2 = {
// 			user: 'kun',
// 			runId: 12,
// 			scriptName: 'testR',
// 			para:['TEST', 'the', 'arguments'],	//given indatabase
// 			input:null,
// 			pre_runs:[{user:'kun',runId:1,scriptName:'testR'}],
// 			outputs:['output1_name','output2_name']	//given in database
// 		}
		
// var runs =[Rrun1,Rrun2];
// var idx=0;
exports.runModels = runModels;
exports.buildRuns = buildRuns;
exports.mkdir_p = mkdir_p;
exports.rimraf = require('./rmdirrf.js').rimraf;
// runModels(runs,idx);
