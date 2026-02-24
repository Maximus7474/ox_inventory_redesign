import React, { useRef } from 'react';
import { Inventory } from '../../typings';
import InventorySlot from './InventorySlot';
import { useAppSelector } from '../../store';
import { imagepath } from '../../store/imagepath';
import { ID_TO_SVG } from '../../utils/config';
import { Locale } from '../../store/locale';

const ClothingGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const containerRef = useRef(null);
  const isBusy = useAppSelector((state) => state.inventory.isBusy);

  return (
    <>
      <div className="inventory-grid-wrapper" style={{ pointerEvents: isBusy ? 'none' : 'auto' }}>
        <div className='inventory-grid-header'>
          <div
            className="inventory-grid-header-label-wrapper"
          >
            <p>{Locale.ui_clothing || 'Clothing'}</p>
          </div>
        </div>
        <div className="inventory-grid-container" ref={containerRef}>
          <>
            {inventory.items.map((item) => (
              <InventorySlot
                key={`${inventory.type}-${inventory.id}-${item.slot}`}
                item={item}
                inventoryType={inventory.type}
                inventoryGroups={inventory.groups}
                inventoryId={inventory.id}
                backgroundIcon={ `${imagepath}/clothing_icons/${ID_TO_SVG[item.slot as keyof typeof ID_TO_SVG] ?? 'none'}`}
              />
            ))}
          </>
        </div>
      </div>
    </>
  );
};

export default ClothingGrid;
