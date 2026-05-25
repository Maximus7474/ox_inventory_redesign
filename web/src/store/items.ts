import { ItemData } from '../typings/item';

export const Items: {
  [key: string]: ItemData | undefined;
} = {
  water: {
    name: 'water',
    close: false,
    label: 'VODA',
    stack: true,
    usable: true,
    count: 0,
  },
  burger: {
    name: 'burger',
    close: false,
    label: 'BURGR',
    stack: false,
    usable: false,
    count: 0,
  },
  lockpick: {
    name: 'lockpick',
    close: true,
    label: 'Lockpick',
    stack: true,
    usable: true,
    count: 0,
  },
  powersaw: {
    name: 'powersaw',
    close: true,
    label: 'Power Saw',
    stack: false,
    usable: true,
    count: 0,
  },
};
