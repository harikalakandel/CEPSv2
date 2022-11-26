% Complex Correlation Measure after Karmaker, 2009
% DJC Dec 2020

% -----------------------------------------------
% meaningless statement to force this to be script not function file
1;




% -----------------------------------------------
% entry pointtest
filename = '.....\Matlab\CCM\runAll.txt';
fid = fopen(filename);

% for each line in file
strline = fgetl(fid);
while ischar(strline)
  if (strncmp(strline, 'load', 4))
    strarray = strsplit(strline);
    vdat = FileRead(strarray{2});
    printf("%d %f %f\n", size(vdat,1), mean(vdat), var(vdat));
  elseif (strncmp(strline, 'ccm', 3) && size(vdat,1) > 5)
    strarray = strsplit(strline);
    lagVal = str2num(strarray{2});
    [SD1, SD2, dCCM] = djcCCM(vdat, lagVal);
    printf("%f %f %f\n", SD1, SD2, dCCM);
  end
  strline = fgetl(fid);
end
fclose(fid);

% -----------------------------------------------
% read contents of a file
function vecData = FileRead(filename)
  disp(filename);
  fid = fopen(filename, 'r');
  vecData = fscanf(fid, '%f');
  fclose(fid);
end


