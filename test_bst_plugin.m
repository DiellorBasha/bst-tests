% filepath: c:\CodingProjects\brainstorm3\toolbox\tests\test_bst_plugin_PETPVE12_CAT12.m
% Test battery for bst_plugin: PETPVE12 and CAT12 plugins

function tests = test_bst_plugin
    tests = functiontests(localfunctions);
end

function testCat12Registration(testCase)
    % Test that the CAT12 plugin is registered and has correct fields
    PlugDesc = bst_plugin('GetSupported', 'cat12');
    verifyEqual(testCase, PlugDesc.Name, 'cat12');
    verifyNotEmpty(testCase, PlugDesc.URLzip);
    verifyNotEmpty(testCase, PlugDesc.TestFile);
    verifyTrue(testCase, ismember('spm12', PlugDesc.RequiredPlugs));
end

function testPetpve12Registration(testCase)
    % Test that the PETPVE12 plugin is registered and has correct fields
    PlugDesc = bst_plugin('GetSupported', 'petpve12');
    verifyEqual(testCase, PlugDesc.Name, 'petpve12');
    verifyNotEmpty(testCase, PlugDesc.URLzip);
    verifyNotEmpty(testCase, PlugDesc.TestFile);
    verifyTrue(testCase, ismember('spm12', PlugDesc.RequiredPlugs));
end

function testCat12InstallAndLoad(testCase)
    % Test that CAT12 can be installed and loaded
    [isOk, errMsg, PlugDesc] = bst_plugin('Install', 'cat12', 0);
    verifyTrue(testCase, isOk, sprintf('CAT12 install failed: %s', errMsg));
    [isOk, errMsg, PlugDesc] = bst_plugin('Load', 'cat12', 0);
    verifyTrue(testCase, isOk, sprintf('CAT12 load failed: %s', errMsg));
    verifyTrue(testCase, PlugDesc.isLoaded == 1);
end

function testPetpve12InstallAndLoad(testCase)
    % Test that PETPVE12 can be installed and loaded
    [isOk, errMsg, PlugDesc] = bst_plugin('Install', 'petpve12', 0);
    verifyTrue(testCase, isOk, sprintf('PETPVE12 install failed: %s', errMsg));
    [isOk, errMsg, PlugDesc] = bst_plugin('Load', 'petpve12', 0);
    verifyTrue(testCase, isOk, sprintf('PETPVE12 load failed: %s', errMsg));
    verifyTrue(testCase, PlugDesc.isLoaded == 1);
end

function testCat12TestFileExists(testCase)
    % Test that the CAT12 test file exists on the path after install
    PlugDesc = bst_plugin('GetInstalled', 'cat12');
    verifyNotEmpty(testCase, PlugDesc, 'CAT12 not installed');
    verifyTrue(testCase, exist(PlugDesc.TestFile, 'file') == 2, ...
        sprintf('CAT12 test file not found: %s', PlugDesc.TestFile));
end

function testPetpve12TestFileExists(testCase)
    % Test that the PETPVE12 test file exists on the path after install
    PlugDesc = bst_plugin('GetInstalled', 'petpve12');
    verifyNotEmpty(testCase, PlugDesc, 'PETPVE12 not installed');
    verifyTrue(testCase, exist(PlugDesc.TestFile, 'file') == 2, ...
        sprintf('PETPVE12 test file not found: %s', PlugDesc.TestFile));
end

function testCat12Uninstall(testCase)
    % Test that CAT12 can be uninstalled
    [isOk, errMsg] = bst_plugin('Uninstall', 'cat12', 0, 1);
    verifyTrue(testCase, isOk, sprintf('CAT12 uninstall failed: %s', errMsg));
    PlugDesc = bst_plugin('GetInstalled', 'cat12');
    verifyTrue(testCase, isempty(PlugDesc), 'CAT12 still installed after uninstall');
end

function testPetpve12Uninstall(testCase)
    % Test that PETPVE12 can be uninstalled
    [isOk, errMsg] = bst_plugin('Uninstall', 'petpve12', 0, 1);
    verifyTrue(testCase, isOk, sprintf('PETPVE12 uninstall failed: %s', errMsg));
    PlugDesc = bst_plugin('GetInstalled', 'petpve12');
    verifyTrue(testCase, isempty(PlugDesc), 'PETPVE12 still installed after uninstall');
end