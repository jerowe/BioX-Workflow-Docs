# Example001

Here is a very simple example that searches a directory for \*.csv files and creates an outdir /home/user/workflow/output if one doesn't exist.

Create the /home/user/workflow/workflow.yml

### workflow.yml

```yaml
    ---
    global:
        - indir: /home/user/workflow
        - outdir: /home/user/workflow/output
        - file_rule: (.*).csv
    rules:
        - rule1:
            process: |
            Rule1
            INDIR: {$self->indir}
            OUTDIR: {$self->outdir}
        - rule2:
            process: |
            Rule2
            INDIR: {$self->indir}
            OUTDIR: {$self->outdir}
        - rule3:
            process: |
            Rule3
            INDIR: {$self->indir}
            OUTDIR: {$self->outdir}
```

Run the script to create out directory structure and workflow bash script

```bash
    biox-workflow.pl --workflow workflow.yml > workflow.sh
```

### The Structure

    /home/user/workflow/
        test1.csv
        test2.csv
        /output
            /rule1
            /rule2
            /rule3
