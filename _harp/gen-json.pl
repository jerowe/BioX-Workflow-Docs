#!/usr/bin/env perl

use JSON;
my $href;

#Global
$href = {
    globals => {
        'sitetags' => [
            "Samples",  "Structure",     "Files", "Directories",
            "Examples", "Configuration", "Rules"
        ],
        pages => [
            { "home" => { "title" => "Home", } },
            {   "findsamples" => {
                    "title" => "Find Samples",
                    tags    => ['Samples']
                }
            },
            {   "workflow" => {
                    "title" => "Workflow",
                    tags    => []
                }
            },
            {   "example001" => {
                    "title" => "Example-001",
                    tags    => ['Examples']
                }
            },
            {   "example002" => {
                    "title" => "Example-002",
                    tags    => ['Examples']
                }
            },
            {   "specialvariables" => {
                    "title" => "Special Variables",
                    tags    => ['configuration']
                }
            },
            {   "showcase" => {
                    "title" => "Showcase",
                    tags    => ['examples']
                }
            },
        ],
        showcase => [ 'rnaseq.yml', 'rename_samples.yml', 'snpcalling.yml' ],
    }
};

$href = {Usage => {layout => "false"}};
#Data
#$href = {
#"home"        => { "title" => "Home", },
#"findsamples" => {
#"title" => "Find Samples",
#tags    => ['Samples']
#},
#"workflow" => {
#"title" => "Workflow",
#tags    => []
#},
#"example001" => {
#"title" => "Example-001",
#tags    => ['Examples']
#},
#"example002" => {
#"title" => "Example-002",
#tags    => ['Examples']
#},
#};

my $json = encode_json $href;
print $json;
