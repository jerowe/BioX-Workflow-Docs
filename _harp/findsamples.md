# Let's Find Some Samples

Possibly the most important part of your workflow is finding samples.

Samples, like variables, come in two flavors. They are files, or they are
directories. The first shows files, and the second directories.

# Examples!

## Samples are Files

### Directory Structure

Samples are files with the sample name and a .csv extension.

```bash
    /home/user/workflow/
        /data
            /raw
                sample1.csv
                sample2.csv
```

### Workflow Configuration

```yaml
    ---
    global:
        - indir: /home/user/workflow/data/raw
        - outdir: /home/user/workflow/data/analysis
        - file_rule: (sample.*).csv$
```

## Samples are Directories

This time the sample names come from a directory, with stuff inside.

### Directory Structure

```yaml
    /path/to/indir
        /sample1
            billions_of_small_files
            from_the_Sequencer
        /sample2
            billions_of_small_files
            from_the_Sequencer
```

### Workflow Configuration

```yaml
    ---
    global:
        - indir: /home/user/workflow/data/raw
        - outdir: /home/user/workflow/data/analysis
        - file_rule: (sample.*)
        - find_by_dir: 1
        - by_sample_outdir: 1
```
