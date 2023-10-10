% %% make clin.mat
% num = [1,2,4,6,7,8,10,11,12,15,17,18,20,21,24,25,26,28,29,30,31,32,33,34,35,36,37,39,41,42,45,47,49,51,52,53,54,55,56,57,58,59,60,61,64,65,68,69,71,72,73,76,78,79,80,81,82,84,86,87,88,91,92,93,94,95,99,100,101,103,104,105,106,108,109,110,111,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,137,139,142,144,145,146,148,149,151,152,153,154,155,156,158,159,160,162,163,164,165,166,167];
% 
% % np = arrayfun(@(x) ['Pat' num2str(x)], num, 'UniformOutput', false);
% 
% T = table(table2array(inputtable(:,1)),table2array(inputtable(:,2)),table2array(inputtable(:,3)),table2array(inputtable(:,4)),table2array(inputtable(:,5)),table2array(inputtable(:,6)),table2array(inputtable(:,8)),table2array(inputtable(:,9)), ...
%     'RowNames',string(num),'VariableNames',{'num','grade','g1','g2','g0','baseline','fx_ratio','fx_days'});
% save("/Users/ksh/MATLAB/Projects/MAMBA/pelvic/clin.mat","T");

% %% make template.mat
% ct_path = "/Volumes/data-1/ksh/pelvic_RIL/data/ct_crop/150.nii";
% ct = niftiread(ct_path);
% ct = ct(91:420,131:350,11:80);
% vox = [0.9765625, 0.9765625, 3];
% 
% mask_path = "/Volumes/data-1/ksh/pelvic_RIL/data/input/mask/150.nii";
% BM = niftiread(mask_path);
% BM = logical(BM);
% save(fullfile('template.mat'),'vox','ct','BM');

% %% make cohort folder
% for i = [1,2,4,6,7,8,10,11,12,15,17,18,20,21,24,25,26,28,29,30,31,32,33,34,35,36,37,39,41,42,45,47,49,51,52,53,54,55,56,57,58,59,60,61,64,65,68,69,71,72,73,76,78,79,80,81,82,84,86,87,88,91,92,93,94,95,99,100,101,103,104,105,106,108,109,110,111,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,137,139,142,144,145,146,148,149,151,152,153,154,155,156,158,159,160,162,163,164,165,166,167]
%     dose_path = "/Volumes/data-1/ksh/pelvic_RIL/data/input/dose/.nii";
%     path = insertAfter(dose_path,'dose/',string(i));
%     dose = niftiread(path);
%     sv = {};
%     sn = store_in_struct(['dose' sv]);
%     out = "cohort/";
%     out_path = insertAfter(out,"cohort/",string(i));
%     save(out_path,"sn")
%     disp(i)
% end

% %% make fractionation
% num = [1,2,4,6,7,8,10,11,12,15,17,18,20,21,24,25,26,28,29,30,31,32,33,34,35,36,37,39,41,42,45,47,49,51,52,53,54,55,56,57,58,59,60,61,64,65,68,69,71,72,73,76,78,79,80,81,82,84,86,87,88,91,92,93,94,95,99,100,101,103,104,105,106,108,109,110,111,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,137,139,142,144,145,146,148,149,151,152,153,154,155,156,158,159,160,162,163,164,165,166,167];
% load('clin.mat', 'T')
% fx = table2array(T(:,8));
% fx = reshape(fx,[1,122]);
% v = arrayfun(@(x,y) {x,y}, num, fx, UniformOutput=false);
% 
% for i = v
%     c = i{1,1};
%     num = cell2mat(c(1));
%     fx = cell2mat(c(2));
%     path = 'cohort_raw/.mat';
%     fin = insertAfter(path,'raw/',string(num));
%     load(fin)
%     d = sn.dose;
%     dose = d .* fx;
%     sv = {};
%     sn = store_in_struct(['dose' sv]);
%     out = 'cohort_fx/.mat';
%     out_fin = insertAfter(out,'fx/',string(num));
%     save(out_fin,"sn");
% end



% %% make BED map
% num = [1,2,4,6,7,8,10,11,12,15,17,18,20,21,24,25,26,28,29,30,31,32,33,34,35,36,37,39,41,42,45,47,49,51,52,53,54,55,56,57,58,59,60,61,64,65,68,69,71,72,73,76,78,79,80,81,82,84,86,87,88,91,92,93,94,95,99,100,101,103,104,105,106,108,109,110,111,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,137,139,142,144,145,146,148,149,151,152,153,154,155,156,158,159,160,162,163,164,165,166,167];
% fx = table2array(inputtable(:,9));
% fx = reshape(fx,[1,122]);
% abr = 3;
% v = arrayfun(@(x,y) {x,y}, num, fx, UniformOutput=false);
% 
% for i = v
%     c = i{1,1};
%     num = cell2mat(c(1));
%     day = cell2mat(c(2));
%     path = 'cohort_fx/.mat';
%     fin = insertAfter(path,'fx/',string(num));
%     load(fin)
%     d = sn.dose;
%     dose = d + d .* ((d./day) ./ abr);
%     sv ={};
%     sn = store_in_struct(['dose' sv]);
%     out = 'cohort/';
%     out_path = insertAfter(out,"t/",string(num));
%     save(out_path, "sn")
%     sp = 'BED_3/.mat';
%     sf = insertAfter(sp,'3/',string(num));
%     save(sf,'dose')    
% end



% %% execute Image_clin_merge
% template_images = 'ct';
% images = 'dose';
% outcome = 'g2'; %g0, g1, g2
% EVOIs = 'dose';
% subsample_grain = [1 1 1];
% clin_vars = {'baseline'};
% vars = {'dose'};
% masks = {'BM'};
% tails = -1;
% % model = "glm"; % @tstat2;
% % fit_pars = {'tail' 'left'};
% save('pelvic.mat',"template_images","images","masks","outcome","EVOIs","subsample_grain","clin_vars","tails")
% 
% clin_table = 'clin.mat';
% path_proc = '';
% conf = 'pelvic.mat';
% 
% [T, CCS] = image_clin_merge('clin_table', clin_table, 'path_proc', path_proc, conf);
% 
% 
% %% execute VBA
% beta = zeros(size(CCS.mfix));
% p = ones(size(CCS.mfix));
% 
% beta(CCS.mfix) = VBmodel(T, CCS.config.outcome, conf, 'mfix', CCS.mfix, ...
%     'vars', CCS.config.vars, 'outs', 'beta');
% p(CCS.mfix) =  perm_test(T, CCS.config.outcome, conf, 'mfix', CCS.mfix, ...
%     'vars', CCS.config.vars, 'subsampling', [4 4 2], 'dump2file', false, 'N', 1000, 'rng', 1);
% 
% % mkdir('res');
% save(fullfile('res', ['out_bed_' outcome]), 'p', 'CCS', 'beta');
% 
% 
% 
% map = -log10(p);
% 
% for i = 1:10
%     subplot(2,10,i), imshow(beta(:,:,i * 3),[],Colormap=hot)
%     subplot(2,10,i+10), imshow(map(:,:,i * 3),[1.3 4],Colormap=hot)
% 
% end
% 
% impixelinfo








