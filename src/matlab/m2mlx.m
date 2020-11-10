function mlxFile = m2mlx(mFile)

if strcmp(version('-release'), '2016b')
    openAndConvert = @matlab.internal.richeditor.openAndSave;
else
    openAndConvert = @matlab.internal.liveeditor.openAndSave;
end

[FILEPATH,NAME,~] = fileparts(mFile);

mlxFile=[FILEPATH,NAME,'.mlx'];

openAndConvert(mFile,mlxFile)

end

