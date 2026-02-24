import React from 'react';
import { debugData } from '../../utils/debugData';
import type { Inventory } from '../../typings';

const DebugMenu: React.FC = () => {
  const triggerInventorySetup = (state: 'normal' | 'shop' | 'crafting') => {
    const leftInventory: Inventory = {
      id: 'test',
      type: 'player',
      slots: 50,
      label: 'Bob Smith',
      // @ts-ignore
      weight: 3000,
      maxWeight: 5000,
      items: [
        { slot: 1, name: 'iron', weight: 3000, count: 5, metadata: { ammo: 3 } },
        { slot: 2, name: 'powersaw', weight: 0, count: 1, metadata: { durability: 75 } },
        { slot: 3, name: 'copper', weight: 100, count: 12, metadata: { type: 'Special' } },
        { slot: 4, name: 'water', weight: 100, count: 1, metadata: { description: 'Generic item description' } },
        { slot: 6, name: 'hat', weight: 100, count: 1, metadata: { label: 'Baseball cap' } },
      ],
    };

    let rightInventory: Inventory = {
      id: 'shop',
      type: 'crafting',
      slots: 5000,
      label: 'Bob Smith',
      // @ts-ignore
      weight: 3000,
      maxWeight: 5000,
      items: [{
        slot: 1,
        name: 'lockpick',
        weight: 500,
        metadata: { description: 'Simple lockpick' },
      }],
    };

    if (state === 'shop') {
      rightInventory = {
        id: 'shop',
        type: 'shop',
        slots: 5,
        label: 'Shop Table',
        items: [{
          slot: 1,
          name: 'lockpick',
          weight: 500,
          // @ts-ignore
          price: 300,
          metadata: { description: 'Simple lockpick' },
        }],
      };
    } else if (state === 'crafting') {
      rightInventory = {
        id: 'shop',
        type: 'crafting',
        slots: 5,
        label: 'Crafting Table',
        weight: 3000,
        maxWeight: 5000,
        items: [{
          slot: 1,
          name: 'lockpick',
          weight: 500,
          // @ts-ignore
          ingredients: { iron: 5, copper: 12, powersaw: 0.1 },
          metadata: { description: 'Craftable lockpick' },
        }],
      };
    }

    debugData([{
      action: 'setupInventory',
      data: { leftInventory, rightInventory },
    }], 500);
  };

  return (
    <div className="debug-sidebar-wrapper">
      <div className="debug-sidebar-header">
        <span>Secondary Inventory</span>
      </div>

      <div className="debug-sidebar-content">
        <button onClick={() => triggerInventorySetup('normal')}>Drop</button>
        <button onClick={() => triggerInventorySetup('shop')}>Shop</button>
        <button onClick={() => triggerInventorySetup('crafting')}>Crafting</button>
      </div>
    </div>
  );
};

export default DebugMenu;
