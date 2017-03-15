# Frequently Asked Questions (FAQ)

## Mismatch of the version of `openSSL` (Linux)

You might be in the situation that you receive the following error:
````
OpenSSL version mismatch. Built against 1000207f, you have 100010bf
````
In that case, you should run the following command:
````
sudo mv <MATLAB_INSTALLATION_PATH>/bin/glnxa64/libcrypto.so.1.0.0 <MATLAB_INSTALLATION_PATH>/bin/glnxa64/libcrypto.so.1.0.0_bk
````
where `<MATLAB_INSTALLATION_PATH>` corresponds to the installation of `MATLAB`, e.g., `/usr/local/MATLAB/R2016b`

## How do I submit a Pull Request?

Once you submit your contribution (menu item 3), you will be presented with a link that leads you directly to the pull request (PR).

## Turn on the verbose mode

If you encounter a problem, or suspect that something is not behaving properly, please run:
```
>> contribute(true)
```
and follow the process as normally. You can also set `gitConf.verbose = true;` in `assets/confDevTools.m`.

## Resolve unexpected behavior - reset

If you encounter unexpected behavior, please try to reset the `devTools` with:
```
>> resetDevTools
```

If you have files or changes that appear and would like to reset your local fork (without re-cloning) again, type:
```
>> resetLocalFork
```

## How can I abort a process?

You can abort any process using `CTRL-C` (hit `CTRL` and `C` on your keyboard).

## How should I name my contribution?

Initiate a contribution per theme/topic/feature/bug fix that you work on. Don't mix features and think of an explicit name, i.e. `bug-fix-function1` or `add-tests-function2`. Avoid generic names, such as `my-great-feature` or `fix` or `contribution-myName`.

## How can I check the history of a file?

You can check the history of a file by typing in MATLAB:
```
>> history('fileName.m')
```
