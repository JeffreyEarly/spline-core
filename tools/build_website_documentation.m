function build_website_documentation(options)
arguments
    options.rootDir = ".."
end
buildFolder = fullfile(options.rootDir,"docs");
sourceFolder = fullfile(options.rootDir,"Documentation","WebsiteDocumentation");

copyfile(sourceFolder,buildFolder);

changelogPath = fullfile(options.rootDir, "CHANGELOG.md");
if isfile(changelogPath)
    header = "---" + newline + ...
             "layout: default" + newline + ...
             "title: Version History" + newline + ...
             "nav_order: 100" + newline + ...
             "---" + newline + newline;
    versionHistoryText = header + fileread(changelogPath);
    versionHistoryFilePath = fullfile(options.rootDir,"docs","version-history.md");
    fid = fopen(versionHistoryFilePath, "w");
    assert(fid ~= -1, "Could not open CHANGELOG.md for writing");
    fwrite(fid, versionHistoryText);
    fclose(fid);
end

websiteRootURL = "spline-core/";
classFolderName = 'Class documentation';
websiteFolder = 'classes';
classes = {'BSpline','InterpolatingSpline','ConstrainedSpline','TensorSpline','ConstrainedTensorSpline','ShapeConstraint'};
clean_generated_class_docs(buildFolder, websiteFolder, classes);
classDocumentation = ClassDocumentation.empty(length(classes),0);
for iName=1:length(classes)
    excludedSuperclasses = {'handle', 'matlab.mixin.Heterogeneous', 'CAAnnotatedClass'};
    excludedMethodNames = string.empty(0,1);
    switch classes{iName}
        case {'InterpolatingSpline','ConstrainedSpline','ConstrainedTensorSpline','ShapeConstraint'}
            excludedSuperclasses = {'handle'};
    end
    switch classes{iName}
        case 'ShapeConstraint'
            excludedMethodNames = ["cellstr","char","colon","empty","eq","intersect","isequal","isequaln","ismember","ne","setdiff","setxor","strcmp","strcmpi","string","strncmp","strncmpi","union"];
    end

    classDocumentation(iName) = ClassDocumentation(classes{iName}, ...
        nav_order=iName, ...
        websiteRootURL=websiteRootURL, ...
        buildFolder=buildFolder, ...
        websiteFolder=websiteFolder, ...
        parent=classFolderName, ...
        excludedSuperclasses=excludedSuperclasses, ...
        excludedMethodNames=excludedMethodNames);
end
arrayfun(@(a) a.writeToFile(),classDocumentation)

end

function clean_generated_class_docs(buildFolder, websiteFolder, classes)
classDocsRoot = fullfile(buildFolder, websiteFolder);
if ~isfolder(classDocsRoot)
    return;
end

expectedFolders = lower(string(classes));
existingEntries = dir(classDocsRoot);
existingFolders = string({existingEntries([existingEntries.isdir]).name});
existingFolders = existingFolders(~ismember(existingFolders, [".", ".."]));

orphanedFolders = setdiff(existingFolders, expectedFolders);
for folderName = orphanedFolders
    rmdir(fullfile(classDocsRoot, folderName), 's');
end

for folderName = expectedFolders
    targetFolder = fullfile(classDocsRoot, folderName);
    if isfolder(targetFolder)
        rmdir(targetFolder, 's');
    end
end
end
