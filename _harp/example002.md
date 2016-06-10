# Example002

Here is a very simple example that searches a directory for \*.csv files and creates an outdir /home/user/workflow/output if one doesn't exist.

Create the /home/user/workflow/workflow.yml

```yaml
    ---
    global:
        - indir: /home/user/workflow/workflow
        - outdir: /home/user/workflow/workflow/output
        - file_rule: (.*).csv$
    rules:
        - backup:
            process: cp {$self->indir}/{$sample}.csv {$self->outdir}/{$sample}.csv
        - grep_VARA:
            process: |
                echo "Working on {$self->{indir}}/{$sample.csv}"
                grep -i "VARA" {$self->indir}/{$sample}.csv >> {$self->outdir}/{$sample}.grep_VARA.csv
        - grep_VARB:
            process: |
                grep -i "VARB" {$self->indir}/{$sample}.grep_VARA.csv >> {$self->outdir}/{$sample}.grep_VARA.grep_VARB.csv
```

Make some test data

```yaml
    cd /home/user/workflow

    #Create test1.csv with some lines
    echo "This is VARA" >> test1.csv
    echo "This is VARB" >> test1.csv
    echo "This is VARC" >> test1.csv

    #Create test2.csv with some lines
    echo "This is VARA" >> test2.csv
    echo "This is VARB" >> test2.csv
    echo "This is VARC" >> test2.csv
    echo "This is some data I don't want" >> test2.csv
```

Run the script to create out directory structure and workflow bash script

```bash
    biox-workflow.pl --workflow workflow.yml > workflow.sh
```

## Look at the directory structure

    /home/user/workflow/
        test1.csv
        test2.csv
        /output
            /backup
            /grep_vara
            /grep_varb

## Run the workflow

Assuming you saved your output to workflow.sh if you run ./workflow.sh you will get the following.

```yaml
    /home/user/workflow/
        test1.csv
        test2.csv
        /output
            /backup
                test1.csv
                test2.csv
            /grep_vara
                test1.grep_VARA.csv
                test2.grep_VARA.csv
            /grep_varb
                test1.grep_VARA.grep_VARB.csv
                test2.grep_VARA.grep_VARB.csv
```

## A closer look at workflow.sh

This top part here is the metadata. It tells you the options used to run the script.

```bash
    #
    # This file was generated with the following options
    #   --workflow      workflow.yml
    #
```

If --verbose is enabled, and it is by default, you'll see some variables printed out for your benefit

```bash
    #
    # Variables
    # Indir: /home/user/workflow
    # Outdir: /home/user/workflow/output/backup
    # Samples: test1    test2
    #
```

Here is out first rule, named backup. As you can see our $self->outdir is automatically named 'backup', relative to the globally defined outdir.

```bash
    #
    # Starting backup
    #

    cp /home/user/workflow/test1.csv /home/user/workflow/output/backup/test1.csv
    cp /home/user/workflow/test2.csv /home/user/workflow/output/backup/test2.csv

    wait

    #
    # Ending backup
    #

```

Notice the 'wait' command. If running your outputted workflow through any of the HPC::Runner scripts, the wait signals to wait until all previous processes have ended before beginning the next one.

Basically, wait builds a linear dependency tree.

For instance, if running this as

    slurmrunner.pl --infile workflow.sh
    #OR
    mcerunner.pl --infile workflow.sh

The "cp blahblahblah" commands would run in parallel, and the next rule would not begin until those processes have finished.
