Getting and Cleaning Data Aug 2014 Course Project
===================

For courera's getting and cleaning data

The expectation for this project is that the samsung dataset already be downloaded into a directory named 'data' below the directory where this runs. 

The link to download is this: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Here is what the directory structure should look like:
<current directory>:
data/
    README.txt
    activity_labels.txt
    features.txt
    features_info.txt
    test/
        <test data here>
    train/
        <train data here>


metadata for the file downloaded:
* "Download date:" "2014-08-23 14:45:44 PDT"
* "Download URL:" "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
* "Downloaded file Information"

             size isdir mode               mtime               ctime               atime        uid
data.zip 62556944 FALSE  644 2014-08-23 14:45:44 2014-08-23 14:45:44 2014-08-23 14:45:15 1609571604

* Downloaded file md5 Checksum: "d29710c9530a31f303801b6bc34bd895" 

Once you have this set up, run the 'run_analysis.R' script to create the tidy_data.txt file as output.