# Workflow

Your workflow is a set of rules and conditions. Conditions come in two flavors,
local and global. Local variables are local to a rule, and go away after that
rule has been processed, while global live throughout each rule iteration.

## Local and Global Variables

Global variables will always be available, but can be overwritten by local
variables contained in your rules.

    ---
    global:
        - indir: /home/user/example-workflow
        - outdir: /home/user/example-workflow/gemini-wrapper
        - file_rule: (.vcf)$|(.vcf.gz)$
        - some_variable: {$self->indir}/file_to_keep_handy
        - ext: txt
    rules:
        - backup:
            local:
                - ext: "backup"
            process: cp {$self->indir}/{$sample}.csv {$self->outdir}/{$sample}.{$self->ext}.csv
        - rule2:
            process: cp {$self->indir}/{$sample}.csv {$self->outdir}/{$sample}.{$self->ext}.csv

## Rules

Rules are processed in the order they appear.

Before any rules are processed, first the samples are found. These are grepped using File::Basename, the indir, and the file\_rule variable. The
default is to get rid of the everything after the final '.' .

## Overriding Processes

By default your process is evaluated as

    foreach my $sample (@{$self->samples}){
        #Get the value from the process key.
    }

If instead you would like to use the infiles, or some other random process that has nothing to do with your samples, you can override the process
template. Make sure to use the previously defined $OUT. For more information see the [Text::Template](https://metacpan.org/pod/Text::Template) man page.

    rules:
        - backup:
            outdir: {$self->ROOT}/datafiles
            override_process: 1
            process: |
                $OUT .= wget {$self->some_globally_defined_parameter}
                {
                foreach my $infile (@{$self->infiles}){
                    $OUT .= "dostuff $infile";
                }
                }
