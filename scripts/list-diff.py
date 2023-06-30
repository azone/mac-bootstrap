#!/usr/bin/env python3

import sys, json 
import subprocess

def diff_message():
    with open('./formulae-list.json') as f:
        list = json.load(f)
    formulae = dict(map(lambda x: (x['name'], x), list))
    old_content = subprocess.check_output(['git', 'show', 'HEAD:formulae-list.json'])
    old_list = json.loads(old_content)
    old_formulae = dict(map(lambda x: (x['name'], x), old_list))

    old_keys = set(old_formulae.keys())
    new_keys = set(formulae.keys())

    added = sorted(new_keys - old_keys)
    removed = sorted(old_keys - new_keys)
    changed = sorted(o for o in old_keys & new_keys if formulae[o]['linked_keg'] != old_formulae[o]['linked_keg'])
    message = []
    if added:
        added_info = ['  - {}({})'.format(f, formulae[f]['linked_keg']) for f in added]
        message.append('Added:\n' + '\n'.join(added_info))
    if removed:
        removed_info = ['  - {}({})'.format(f, old_formulae[f]['linked_keg']) for f in removed]
        message.append('Removed:\n' + '\n'.join(removed_info))
    if changed:
        changed_info = ['  - {}({} -> {})'.format(f, old_formulae[f]['linked_keg'], formulae[f]['linked_keg']) for f in changed]
        message.append('Updated:\n' + '\n'.join(changed_info))
    return '\n\n'.join(message)

def cask_diff_message():
    with open('./installed-casks.json') as f:
        list = json.load(f)
    casks = dict(map(lambda x: (x['token'], x), list))
    try:
        old_content = subprocess.check_output(['git', 'show', 'HEAD:installed-casks.json'], stderr=subprocess.DEVNULL)
        old_list = json.loads(old_content)
        old_casks = dict(map(lambda x: (x['token'], x), old_list))
    except subprocess.CalledProcessError:
        old_casks = {}

    old_keys = set(old_casks.keys())
    new_keys = set(casks.keys())

    added = sorted(new_keys - old_keys)
    removed = sorted(old_keys - new_keys)
    changed = sorted(o for o in old_keys & new_keys if casks[o]['installed'] != old_casks[o]['installed'])
    message = []
    if added:
        added_info = ['  - {}({})'.format(f, casks[f]['installed']) for f in added]
        message.append('Added:\n' + '\n'.join(added_info))
    if removed:
        removed_info = ['  - {}({})'.format(f, old_casks[f]['installed']) for f in removed]
        message.append('Removed:\n' + '\n'.join(removed_info))
    if changed:
        changed_info = ['  - {}({} -> {})'.format(f, old_casks[f]['installed'], casks[f]['installed']) for f in changed]
        message.append('Updated:\n' + '\n'.join(changed_info))
    return '\n\n'.join(message)

def crate_diff_message():
    with open('./installed-crates-bins.txt') as f:
        list = f.readlines()
    crates = dict(map(lambda x: x.strip().split(' '), list))
    try:
        old_content = subprocess.check_output(['git', 'show', 'HEAD:installed-crates-bins.json'], stderr=subprocess.DEVNULL)
        old_list = old_content.decode('utf-8').split('\n')
        old_crates = dict(map(lambda x: x.strip().split(' '), old_list))
    except subprocess.CalledProcessError:
        old_crates = {}

    old_keys = set(old_crates.keys())
    new_keys = set(crates.keys())

    added = sorted(new_keys - old_keys)
    removed = sorted(old_keys - new_keys)
    changed = sorted(o for o in old_keys & new_keys if crates[o] != old_crates[o])
    message = []
    if added:
        added_info = ['  - {}({})'.format(f, crates[f]) for f in added]
        message.append('Added:\n' + '\n'.join(added_info))
    if removed:
        removed_info = ['  - {}({})'.format(f, old_crates[f]) for f in removed]
        message.append('Removed:\n' + '\n'.join(removed_info))
    if changed:
        changed_info = ['  - {}({} -> {})'.format(f, old_crates[f], crates[f]) for f in changed]
        message.append('Updated:\n' + '\n'.join(changed_info))

    return '\n\n'.join(message)
    

if __name__ == '__main__':
    messages = []
    formulae_message = diff_message()
    if formulae_message:
        messages.append(
            'Formulae\n----------\n' + formulae_message
        )

    cask_message = cask_diff_message()
    if cask_message:
        messages.append('Casks:\n----------\n' + cask_message)

    crate_message = crate_diff_message()
    if crate_message:
        messages.append('Crates:\n----------\n' + crate_message)

    print('\n\n'.join(messages))
