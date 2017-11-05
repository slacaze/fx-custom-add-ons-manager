# MATLAB Custom Add-Ons Manager Toolbox
This repo provides a suite of basic functions to help create, develop, and manage MATLAB Add-Ons (i.e., toolboxes).

## Acknowledgement
This repo was inspired by the following two MathWorks Blog posts:

[Give Them a Care Package](https://blogs.mathworks.com/developer/2016/12/14/give-them-a-care-package/)

[Best Practices - Adapt, then Adopt!](https://blogs.mathworks.com/developer/2017/01/13/matlab-toolbox-best-practices/)

As well as this FileExchange submission:

[Toolbox Tools](https://uk.mathworks.com/matlabcentral/fileexchange/60070-toolbox-tools)

## Basic Concepts
This code relies on the notion of "sandbox" and of some conventions:

1. The sandbox is primarily defined by the PRJ file.
2. The sandbox configuration is supplemented by the "mcam.json" file.
3. The sandbox will package the "code" folder.
4. A single folder will be added to the MATLAB path, "code/`shortname`".

## Commands

* `mksandbox` Create a new sandbox.
* `addsandbox` Add the sandbox to the MATLAB path.
* `rmsandbox` Remove the sandbox from the MATLAB path.
* `testsandbox` Run the tests of the sandbox.
* `testaddon` Run the tests on the packaged Add-On.
* `packagesandbox` Package the sandbox into an MLTBX.
