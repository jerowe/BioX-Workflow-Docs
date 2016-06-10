# Example003

Here is a very simple example that searches a directory for \*.csv files and creates an outdir /home/user/workflow/output if one doesn't exist.

In addition, it searches for samples by directory, and each outdir as
{$sample}/rule

Create the /home/user/workflow/workflow.yml

```yaml
    ---
    global:
        - indir: /home/user/workflow/workflow/input
        - outdir: /home/user/workflow/workflow/output
        - file_rule: (.*)
        - find_by_dir: 1
        - by_sample_outdir: 1
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
    cd /home/user/workflow/input
    mkdir test1
    mkdir test2

    #Create test1.csv with some lines
    echo "This is VARA" >> test1/test1.csv
    echo "This is VARB" >> test1/test1.csv
    echo "This is VARC" >> test1/test1.csv

    #Create test2.csv with some lines
    echo "This is VARA" >> test2/test2.csv
    echo "This is VARB" >> test2/test2.csv
    echo "This is VARC" >> test2/test2.csv
    echo "This is some data I don't want" >> test2/test2.csv
```

Run the script to create out directory structure and workflow bash script

```bash
    biox-workflow.pl --workflow workflow.yml > workflow.sh
```

## Look at the directory structure

```bash
    /home/user/workflow/input
        test1/test1.csv
        test2/test2.csv
        /output
            /test1
                /backup
                /grep_vara
                /grep_varb
            /test2
                /backup
                /grep_vara
                /grep_varb
```

## Run the workflow

Assuming you saved your output to workflow.sh if you run ./workflow.sh you will get the following.

```yaml
    /home/user/workflow/input
        test1/test1.csv
        test2/test2.csv
        /output
            /test1
                /backup
                    test1.csv
                /grep_vara
                    test1.grep_VARA.csv
                /grep_varb
                    test1.grep_VARA.grep_VARB.csv
            /test2
                /backup
                    test2.csv
                /grep_vara
                    test2.grep_VARA.csv
                /grep_varb
                    test2.grep_VARA.grep_VARB.csv
```
