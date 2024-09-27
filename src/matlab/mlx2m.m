function mFile = mlx2m(mlxFile)

if strcmp(version('-release'), '2016b')
    openAndConvert = @matlab.internal.richeditor.openAndConvert;
else
    openAndConvert = @matlab.internal.liveeditor.openAndConvert;
end

[FILEPATH,NAME,~] = fileparts(mlxFile);

mFile=[FILEPATH filesep NAME,'.m'];

openAndConvert(mlxFile,mFile)

end

