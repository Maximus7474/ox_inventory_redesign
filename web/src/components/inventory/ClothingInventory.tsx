import InventoryGrid from './InventoryGrid';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import { CLOTHING_END_IDX, CLOTHING_START_IDX } from '../../utils/config';
import ClothingGrid from './ClothingGrid';

const ClothingInventory: React.FC = () => {
  const leftInventory = useAppSelector(selectLeftInventory);

  return <ClothingGrid inventory={{
    ...leftInventory,
    items: leftInventory.items.slice(CLOTHING_START_IDX, CLOTHING_END_IDX)
  }} />;
};

export default ClothingInventory;
