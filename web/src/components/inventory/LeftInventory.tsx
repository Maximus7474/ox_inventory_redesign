import InventoryGrid from './InventoryGrid';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import { CLOTHING_END_IDX, CLOTHING_START_IDX } from '../../utils/config';

const LeftInventory: React.FC = () => {
  const leftInventory = useAppSelector(selectLeftInventory);

  return <InventoryGrid
    inventory={{
      ...leftInventory,
      items: [
        ...leftInventory.items.slice(0, CLOTHING_START_IDX),
        ...leftInventory.items.slice(CLOTHING_END_IDX),
      ]
    }}
    extraItems={
      leftInventory.items.slice(CLOTHING_START_IDX, CLOTHING_END_IDX)
    }
  />;
};

export default LeftInventory;
