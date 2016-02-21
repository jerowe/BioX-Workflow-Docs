# Customizing your output and special variables

BioX::Workflow uses a few conventions and special variables. As you
probably noticed these are indir, outdir, infiles, and file\_rule. In addition
sample is the currently scoped sample. Infiles is not used by default, but is
simply a store of all the original samples found when the script is first run,
before any processes. In the above example the $self->infiles would evaluate as
\['test1.csv', 'test2.csv'\].

Variables are interpolated using [Interpolation](https://metacpan.org/pod/Interpolation) and [Text::Template](https://metacpan.org/pod/Text::Template). All
variables, unless explictly defined with "$my variable = "stuff"" in your
process key, must be referenced with $self, and surrounded with brackets {}.
Instead of $self->outdir, it should be {$self->outdir}. It is also possible to
define variables with other variables in this way. Everything is referenced
with $self in order to dynamically pass variables to Text::Template. The sample
variable, $sample, is the exception because it is defined in the loop. In
addition you can create INPUT/OUTPUT variables to clean up your process
code. These are special variables that are also used in Drake. Please see [BioX::Workflow::Plugin::Drake](https://metacpan.org/pod/BioX::Workflow::Plugin::Drake)
for more details.

```yaml
    ---
    global:
        - ROOT: /home/user/workflow
        - indir: {$self->ROOT}
        - outdir: {$self->indir}/output
    rules:
        - backup:
            local:
                - INPUT: {$self->indir}/{$sample}.in
                - OUTPUT: {$self->outdir}/{$sample}.out
```
