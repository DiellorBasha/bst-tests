% filepath: c:\CodingProjects\brainstorm3\toolbox\tests\test_mri_rescale.m
% Test battery for mri_rescale

function tests = test_mri_rescale
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    % Set up real or mock MRI file and subject for testing
    % Update these paths/names to match your test environment
    testCase.TestData.MriFile = 'path/to/real_mri_file.mat'; % <-- update this
    testCase.TestData.AtlasName = 'ASEG'; % <-- update if needed
    testCase.TestData.RoiName = 'Cerebellum'; % <-- update if needed
    % Load sMri structure if file exists
    if exist(testCase.TestData.MriFile, 'file')
        testCase.TestData.sMri = in_mri_bst(testCase.TestData.MriFile);
        [sSubject, ~] = bst_get('MriFile', testCase.TestData.MriFile);
        testCase.TestData.sSubject = sSubject;
    else
        testCase.TestData.sMri = [];
        testCase.TestData.sSubject = [];
    end
end

function testListAtlasLabels(testCase)
    % Test listing atlas labels only
    [atlasLabels, MriFileRescale, errMsg, fileTag] = mri_rescale([], testCase.TestData.AtlasName, []);
    verifyTrue(testCase, iscell(atlasLabels));
    verifyEmpty(testCase, MriFileRescale);
    verifyEmpty(testCase, errMsg);
    verifyEmpty(testCase, fileTag);
end

function testRescaleWithFile(testCase)
    % Test rescaling with MRI file input
    if isempty(testCase.TestData.sMri), return; end
    [atlasLabels, MriFileRescale, errMsg, fileTag] = mri_rescale( ...
        testCase.TestData.MriFile, testCase.TestData.AtlasName, testCase.TestData.RoiName);
    verifyTrue(testCase, iscell(atlasLabels));
    verifyTrue(testCase, isempty(errMsg));
    verifyTrue(testCase, ischar(MriFileRescale) || isempty(MriFileRescale));
    verifyTrue(testCase, ischar(fileTag) || isempty(fileTag));
end

function testRescaleWithStruct(testCase)
    % Test rescaling with sMri structure input
    if isempty(testCase.TestData.sMri) || isempty(testCase.TestData.sSubject), return; end
    [atlasLabels, sMriRescale, errMsg, fileTag] = mri_rescale( ...
        testCase.TestData.sMri, testCase.TestData.AtlasName, testCase.TestData.RoiName, testCase.TestData.sSubject);
    verifyTrue(testCase, iscell(atlasLabels));
    verifyTrue(testCase, isempty(errMsg));
    verifyTrue(testCase, isstruct(sMriRescale) || isempty(sMriRescale));
    verifyTrue(testCase, ischar(fileTag) || isempty(fileTag));
end

function testMissingSubjectError(testCase)
    % Test error when sSubject is missing for struct input
    if isempty(testCase.TestData.sMri), return; end
    [~, ~, errMsg, ~] = mri_rescale(testCase.TestData.sMri, testCase.TestData.AtlasName, testCase.TestData.RoiName);
    verifyNotEmpty(testCase, errMsg);
end

function testInvalidFileError(testCase)
    % Test error with invalid MRI file
    [~, ~, errMsg, ~] = mri_rescale('not_a_real_file.mat', testCase.TestData.AtlasName, testCase.TestData.RoiName);
    verifyNotEmpty(testCase, errMsg);
end

function testInvalidRoiError(testCase)
    % Test error with invalid ROI name
    if isempty(testCase.TestData.sMri) || isempty(testCase.TestData.sSubject), return; end
    [~, ~, errMsg, ~] = mri_rescale(testCase.TestData.sMri, testCase.TestData.AtlasName, 'not_a_real_roi', testCase.TestData.sSubject);
    verifyNotEmpty(testCase, errMsg);
end

function testEmptyRoiError(testCase)
    % Test error with empty ROI name
    if isempty(testCase.TestData.sMri) || isempty(testCase.TestData.sSubject), return; end
    [~, ~, errMsg, ~] = mri_rescale(testCase.TestData.sMri, testCase.TestData.AtlasName, '', testCase.TestData.sSubject);
    verifyNotEmpty(testCase, errMsg);
end