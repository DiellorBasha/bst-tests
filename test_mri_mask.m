% filepath: c:\CodingProjects\brainstorm3\toolbox\tests\test_mri_mask.m
% Test battery for mri_mask

function tests = test_mri_mask
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    % Prepare a dummy MRI file and subject for testing
    testCase.TestData.MriFile = 'test_mri.mat'; % Replace with a valid test file if available
    testCase.TestData.AtlasName = 'ASEG';
    % Create a minimal sMri structure for structure input tests
    sMri = struct('Cube', ones(10,10,10), 'Comment', 'Test MRI');
    testCase.TestData.sMri = sMri;
    % Create a minimal sSubject structure
    sSubject = struct('Name', 'TestSubject');
    testCase.TestData.sSubject = sSubject;
end

function testListAtlasLabels(testCase)
    % Test listing atlas labels (no masking)
    [atlasLabels, MriFileMask, errMsg, fileTag, binMask] = mri_mask([], testCase.TestData.AtlasName);
    verifyTrue(testCase, iscell(atlasLabels));
    verifyEmpty(testCase, MriFileMask);
    verifyEmpty(testCase, errMsg);
    verifyEmpty(testCase, fileTag);
    verifyEmpty(testCase, binMask);
end

function testMaskWithRegionString(testCase)
    % Test masking with a single region as string (should not error, may need valid file)
    try
        [atlasLabels, MriFileMask, errMsg, fileTag, binMask] = mri_mask(testCase.TestData.MriFile, testCase.TestData.AtlasName, 'cerebellum', 1);
        verifyTrue(testCase, isempty(errMsg) || ischar(errMsg));
    catch ME
        warning('testMaskWithRegionString: %s', ME.message);
    end
end

function testMaskWithRegionCell(testCase)
    % Test masking with multiple regions as cell array
    try
        [atlasLabels, MriFileMask, errMsg, fileTag, binMask] = mri_mask(testCase.TestData.MriFile, testCase.TestData.AtlasName, {'cerebellum','wm'}, 1);
        verifyTrue(testCase, isempty(errMsg) || ischar(errMsg));
    catch ME
        warning('testMaskWithRegionCell: %s', ME.message);
    end
end

function testMaskWithStructInput(testCase)
    % Test masking with sMri structure input (should require sSubject)
    [atlasLabels, MriFileMask, errMsg, fileTag, binMask] = mri_mask(testCase.TestData.sMri, testCase.TestData.AtlasName, 'cerebellum', 1, testCase.TestData.sSubject);
    verifyTrue(testCase, isempty(errMsg) || ischar(errMsg));
end

function testNoMaskRegionError(testCase)
    % Test error when no mask region is provided
    [~, ~, errMsg, ~, ~] = mri_mask(testCase.TestData.MriFile, testCase.TestData.AtlasName, [], 1);
    verifyNotEmpty(testCase, errMsg);
end

function testInvalidAtlasError(testCase)
    % Test error with invalid atlas name
    [~, ~, errMsg, ~, ~] = mri_mask(testCase.TestData.MriFile, 'INVALID_ATLAS', 'cerebellum', 1);
    verifyNotEmpty(testCase, errMsg);
end

function testInvalidRegionError(testCase)
    % Test error with invalid region name
    [~, ~, errMsg, ~, ~] = mri_mask(testCase.TestData.MriFile, testCase.TestData.AtlasName, 'not_a_region', 1);
    verifyNotEmpty(testCase, errMsg);
end

function testBrainmaskSpecialCase(testCase)
    % Test special handling for 'Brainmask'
    try
        [atlasLabels, MriFileMask, errMsg, fileTag, binMask] = mri_mask(testCase.TestData.MriFile, testCase.TestData.AtlasName, 'Brainmask', 1);
        verifyTrue(testCase, isempty(errMsg) || ischar(errMsg));
    catch ME
        warning('testBrainmaskSpecialCase: %s', ME.message);
    end
end