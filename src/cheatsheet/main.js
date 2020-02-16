/*- === Cheatsheet ===
---
--- Main cheatsheet script for rendering shortcut blocks
-*/
'use strict'

const Fuse = require('fuse.js');

const flattenedShortcuts = window.SHORTCUT_BLOCKS
    .reduce((acc, block) => [ ...acc, ...block.filter(s => !s.isTitle) ], []);

const fuse = new Fuse(flattenedShortcuts, {
    threshold: 0.2,
    keys: ['name'],
});

const input = document.getElementById('search');
const columns = document.getElementById('columns');

// Create div with class name
function createDiv(className) {
    const div = document.createElement("div");
    div.className = className;
    return div;
}

// Create shortcut block item div containing the hotkey and title
function createBlockItem(shortcut) {
    const titleClassName = shortcut.isTitle ? 'block-item-title' : '';
    const shortcutItemDiv = createDiv(`block-item ${titleClassName}`);
    const hotkeyDiv = createDiv('shortcut-hotkey');
    const titleDiv = createDiv('shortcut-title');

    hotkeyDiv.appendChild(document.createTextNode(shortcut.hotkey || ''));
    titleDiv.appendChild(document.createTextNode(shortcut.name));
    shortcutItemDiv.appendChild(hotkeyDiv);
    shortcutItemDiv.appendChild(titleDiv);

    return shortcutItemDiv;
}

// Add shortcut blocks with specific shortcut ids (empty list will return all shortcuts)
function addShortcutBlocks(ids = []) {
    window.SHORTCUT_BLOCKS.forEach(shortcuts => {
        const block = createDiv('block');

        shortcuts.forEach(shortcut => {
            if (shortcut.isTitle || !ids.length || ids.includes(shortcut.id)) {
                block.appendChild(createBlockItem(shortcut))
            }
        })

        columns.appendChild(block);
    });
}

// Wipe all previous shortcut blocks and re-add with new input value
input.oninput = function handleSearchInput(event) {
    let child = columns.lastElementChild;

    while (child) {
        columns.removeChild(child);
        child = columns.lastElementChild;
    }

    let ids = [];
    if (event.target.value) {
        const results = fuse.search(event.target.value);
        ids = results.map(shortcut => shortcut.id);
    }

    addShortcutBlocks(ids);
}

addShortcutBlocks();
