import React, { useEffect, useState } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import InventoryControl from './InventoryControl';
import InventoryHotbar from './InventoryHotbar';
import { useAppDispatch } from '../../store';
import { refreshSlots, setAdditionalMetadata, setupInventory } from '../../store/inventory';
import { useExitListener } from '../../hooks/useExitListener';
import { Inventory as InventoryProps, InventoryType } from '../../typings';
import RightInventory from './RightInventory';
import LeftInventory from './LeftInventory';
import Tooltip from '../utils/Tooltip';
import { closeTooltip } from '../../store/tooltip';
import InventoryContext from './InventoryContext';
import { closeContextMenu } from '../../store/contextMenu';
import Fade from '../utils/transitions/Fade';
import ClothingInventory from './ClothingInventory';

const INV_TYPES_FORCE_SWITCH = [
  InventoryType.CONTAINER,
  InventoryType.SHOP,
  InventoryType.STASH,
  InventoryType.CRAFTING,
  InventoryType.PLAYER,
  InventoryType.TRUNK,
  InventoryType.NEWDROP,
]

const SecondaryInventory: React.FC<{ showClothing: boolean }> = ({ showClothing }) => {
  return (
    showClothing
      ? <RightInventory />
      : <ClothingInventory />
  );
}

const Inventory: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = useState(false);
  const [showClothing, setHideClothing] = useState<boolean>(false);
  const dispatch = useAppDispatch();

  const toggleClothing = (state: boolean) => {
    if (state === showClothing) return;
    localStorage.setItem('clothingTab', `${state}`);
    setHideClothing(state);
  }

  useNuiEvent<boolean>('setInventoryVisible', setInventoryVisible);
  useNuiEvent<false>('closeInventory', () => {
    setInventoryVisible(false);
    dispatch(closeContextMenu());
    dispatch(closeTooltip());
  });
  useExitListener(setInventoryVisible);

  useNuiEvent<{
    leftInventory?: InventoryProps;
    rightInventory?: InventoryProps;
  }>('setupInventory', (data) => {
    dispatch(setupInventory(data));
    !inventoryVisible && setInventoryVisible(true);

    if (!data.rightInventory) return;

    const rightInvType = data.rightInventory.type as InventoryType;

    if (!INV_TYPES_FORCE_SWITCH.includes(rightInvType)) return;

    setHideClothing(rightInvType !== InventoryType.NEWDROP);
  });

  useNuiEvent('refreshSlots', (data) => dispatch(refreshSlots(data)));

  useNuiEvent('displayMetadata', (data: Array<{ metadata: string; value: string }>) => {
    dispatch(setAdditionalMetadata(data));
  });

  useEffect(() => {
    const prevState = localStorage.getItem('clothingTab');

    if (!prevState) return;

    setHideClothing(prevState === 'true');
  }, []);

  return (
    <>
      <Fade in={inventoryVisible}>
        <div className="inventory-wrapper">
          <div className="inventory-grids">
            <LeftInventory />

            <InventoryControl toggleClothing={toggleClothing} showClothing={showClothing} />

            <SecondaryInventory showClothing={showClothing} />
          </div>

          <Tooltip />
          <InventoryContext />
        </div>
      </Fade>
      <InventoryHotbar />
    </>
  );
};

export default Inventory;
