/*- === Cheatsheet ===
---
--- Main cheatsheet script for rendering shortcut blocks
-*/
'use strict'

const Fuse = require('fuse.js');

const flattenedShortcuts = window.SHORTCUT_BLOCKS.reduce((acc, block) => [ ...acc, ...block ], []);

const fuse = new Fuse(flattenedShortcuts, {
    threshold: 0.1,
    distance: 1000,
    keys: ['name'],
});

const input = document.getElementById('search');
const columns = document.getElementById('columns');
const [ content ] = document.getElementsByClassName('content');

document.addEventListener('keydown', event => {
    event.stopPropagation();

    if (event.ctrlKey && event.key === 'j') {
        content.scrollTop += 50;
    }
    if (event.ctrlKey && event.key === 'k') {
        content.scrollTop -= 50;
    }
    if (event.ctrlKey && event.key === 'd') {
        content.scrollTop += window.innerHeight / 2;
    }
    if (event.ctrlKey && event.key === 'u') {
        content.scrollTop -= window.innerHeight / 2;
    }
});

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

    if (shortcut.isUnmapped) {
        const p = document.createElement('p');
        p.className = 'unmapped-label';
        p.appendChild(document.createTextNode('(unmapped)'));
        titleDiv.appendChild(p);
    }

    shortcutItemDiv.appendChild(hotkeyDiv);
    shortcutItemDiv.appendChild(titleDiv);

    return shortcutItemDiv;
}

// Add shortcut blocks with specific shortcut ids (empty list will return all shortcuts)
function addShortcutBlocks(ids = []) {
    window.SHORTCUT_BLOCKS.forEach(shortcuts => {
        const block = createDiv('block');
        const blocks = [];

        shortcuts.forEach(shortcut => {
            if (shortcut.isTitle || !ids.length || ids.includes(shortcut.id)) {
                blocks.push(createBlockItem(shortcut))
            }
        })

        if (blocks.length > 1) {
            blocks.forEach(blockItem => block.appendChild(blockItem))
            columns.appendChild(block);
            return
        }
    });
}

// Wipe all previous shortcut blocks and re-add with new input value
input.oninput = function handleSearchInput(event) {
    let child = columns.lastElementChild;

    while (child) {
        columns.removeChild(child);
        child = columns.lastElementChild;
    }

    let ids = new Set();
    if (event.target.value) {
        const results = fuse.search(event.target.value);
        const matchedShortcutIds = results.map(shortcut => shortcut.id);

        // Include all shortcuts under matched category titles
        const matchedCategoryTitles = results.filter(result => result.isTitle);
        const matchedCategoryShortcutIds = matchedCategoryTitles.reduce((acc, title) => {
            const shortcutBlock =  window.SHORTCUT_BLOCKS.find(block => block[0].id === title.id);
            return [ ...acc, ...shortcutBlock.map(shortcut => shortcut.id) ];
        }, []);

        ids = new Set([
            ...matchedShortcutIds,
            ...matchedCategoryShortcutIds,
        ]);
    }

    addShortcutBlocks(Array.from(ids));
}

addShortcutBlocks();
