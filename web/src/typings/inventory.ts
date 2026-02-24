import { Slot } from './slot';

export enum InventoryType {
  PLAYER = 'player',
  SHOP = 'shop',
  CONTAINER = 'container',
  CRAFTING = 'crafting',
  NEWDROP = 'newdrop',
  DROP = 'drop',
  POLICEEVIDENCE = 'policeevidence',
  STASH = 'stash',
  GLOVEBOX = 'glovebox',
  TRUNK = 'trunk',
}

export type Inventory = {
  id: string;
  type: string;
  slots: number;
  items: Slot[];
  maxWeight?: number;
  label?: string;
  groups?: Record<string, number>;
};
