import diff_match_patch as dmp_module
import sys
import os

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

def main():
    try:
        base_text = read_file('current.md')
        
        proposals = ['00', '01', '02', '03']
        
        dmp = dmp_module.diff_match_patch()
        
        patches = []
        for proposal_num in proposals:
            proposal_file = f'{proposal_num}.md'
            if not os.path.exists(proposal_file):
                print(f"Warning: Proposal file not found: {proposal_file}", file=sys.stderr)
                continue

            proposal_text = read_file(proposal_file)
            patch = dmp.patch_make(base_text, proposal_text)
            patches.extend(patch)

        final_text, results = dmp.patch_apply(patches, base_text)

        if not all(results):
            print(f"Error applying patches", file=sys.stderr)
            # In case of failure, it's hard to know which patch failed, so we don't write a reject file.
            sys.exit(1)

        with open('final.md', 'w', encoding='utf-8') as f:
            f.write(final_text)

    except FileNotFoundError as e:
        print(f"Error: {e}. Make sure all proposal files and current.md exist.", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
