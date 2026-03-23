function build_website_documentation(options)
arguments
    options.rootDir = ".."
end
rootDir = char(java.io.File(char(options.rootDir)).getCanonicalPath());
buildFolder = fullfile(rootDir,"docs");
sourceFolder = fullfile(rootDir,"Documentation","WebsiteDocumentation");
previousBuildFolder = "";

if isfolder(fullfile(buildFolder, "tutorials"))
    previousBuildFolder = tempname();
    mkdir(previousBuildFolder);
    copyfile(fullfile(buildFolder, "tutorials"), fullfile(previousBuildFolder, "tutorials"));
end

if isfolder(buildFolder)
    rmdir(buildFolder, "s");
end
copyfile(sourceFolder,buildFolder);

changelogPath = fullfile(rootDir, "CHANGELOG.md");
if isfile(changelogPath)
    header = "---" + newline + ...
             "layout: default" + newline + ...
             "title: Version History" + newline + ...
             "nav_order: 100" + newline + ...
             "---" + newline + newline;
    versionHistoryText = header + fileread(changelogPath);
    versionHistoryFilePath = fullfile(rootDir,"docs","version-history.md");
    fid = fopen(versionHistoryFilePath, "w");
    assert(fid ~= -1, "Could not open CHANGELOG.md for writing");
    fwrite(fid, versionHistoryText);
    fclose(fid);
end

tutorialSources = {
    fullfile(rootDir, "Examples", "Tutorials", "InterpolatingSplineBasics.m")
    fullfile(rootDir, "Examples", "Tutorials", "IntroductionToBSplines.m")
    fullfile(rootDir, "Examples", "Tutorials", "RobustSplineFitting.m")
    fullfile(rootDir, "Examples", "Tutorials", "LocalPointConstraints1D.m")
    fullfile(rootDir, "Examples", "Tutorials", "GlobalShapeConstraints.m")
    fullfile(rootDir, "Examples", "Tutorials", "MaskConstrainedFit.m")
    fullfile(rootDir, "Examples", "Tutorials", "ScatteredDataFitting2D.m")
};
tutorialDocumentation = TutorialDocumentation.documentationFromSourceFiles(tutorialSources, ...
    buildFolder=buildFolder, ...
    websiteRootURL="spline-core/", ...
    websiteFolder="tutorials", ...
    sourceRoot=rootDir, ...
    previousBuildFolder=previousBuildFolder, ...
    executionPaths=string(rootDir));
TutorialDocumentation.writeMarkdownIndex(tutorialDocumentation, ...
    buildFolder=buildFolder, ...
    websiteFolder="tutorials", ...
    nav_order=5);
arrayfun(@(a) a.writeToFile(), tutorialDocumentation)
clear tutorialDocumentation
if previousBuildFolder ~= "" && isfolder(previousBuildFolder)
    rmdir(previousBuildFolder, "s");
end

% Running tutorials instantiates classes like InterpolatingSpline. MATLAB can
% then return stripped method/property comment metadata until the class cache
% is cleared, which breaks the generated API pages.
evalin('base', 'clear classes');
evalin('base', 'rehash');

websiteRootURL = "spline-core/";
classFolderName = 'Class documentation';
websiteFolder = 'classes';
constraintFolderName = 'Constraint classes';
constraintWebsiteFolder = 'classes/constraints';
classes = {'BSpline','TensorSpline','InterpolatingSpline','ConstrainedSpline'};
constraintClasses = {'SplineConstraint','PointConstraint','GlobalConstraint'};
allClasses = [classes, constraintClasses];
classDocumentation = ClassDocumentation.empty(length(allClasses),0);
for iName=1:length(allClasses)
    className = allClasses{iName};
    excludedSuperclasses = {'handle', 'matlab.mixin.Heterogeneous', 'CAAnnotatedClass'};
    excludedMethodNames = string.empty(0,1);
    switch className
        case {'InterpolatingSpline','ConstrainedSpline'}
            excludedSuperclasses = {'handle'};
    end
    currentWebsiteFolder = websiteFolder;
    currentParent = classFolderName;
    currentNavOrder = iName;
    if ismember(className, constraintClasses)
        currentWebsiteFolder = constraintWebsiteFolder;
        currentParent = constraintFolderName;
        currentNavOrder = iName - numel(classes);
    end

    classDocumentation(iName) = ClassDocumentation(className, ...
        nav_order=currentNavOrder, ...
        websiteRootURL=websiteRootURL, ...
        buildFolder=buildFolder, ...
        websiteFolder=currentWebsiteFolder, ...
        parent=currentParent, ...
        excludedSuperclasses=excludedSuperclasses, ...
        excludedMethodNames=excludedMethodNames);
end
arrayfun(@(a) a.writeToFile(),classDocumentation)
trimTrailingWhitespaceInMarkdown(buildFolder)

end

function trimTrailingWhitespaceInMarkdown(rootFolder)
markdownFiles = dir(fullfile(rootFolder, "**", "*.md"));
for iFile = 1:numel(markdownFiles)
    filePath = fullfile(markdownFiles(iFile).folder, markdownFiles(iFile).name);
    fileText = fileread(filePath);
    trimmedText = regexprep(fileText, '[ \t]+(\r?\n)', '$1');
    if ~strcmp(fileText, trimmedText)
        fid = fopen(filePath, "w");
        assert(fid ~= -1, "Could not open markdown file for writing");
        fwrite(fid, trimmedText);
        fclose(fid);
    end
end
end
