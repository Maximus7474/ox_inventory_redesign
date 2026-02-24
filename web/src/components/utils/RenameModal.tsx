import React, { useState } from 'react';
import { Locale } from '../../store/locale';

interface RenameModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (newName: string) => void;
}

const RenameModal: React.FC<RenameModalProps> = ({ isOpen, onClose, onSubmit }) => {
  const [newName, setNewName] = useState('');

  if (!isOpen) return null;

  const handleSubmit = () => {
    onSubmit(newName);
    setNewName('');
    onClose();
  };

  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 1000,
      }}
    >
      <div
        className="rename-modal"
      >
        <h1 className='rename-modal-title'>{Locale.ui_renameTitle || "Rename Item"}</h1>
        <input
          type="text"
          value={newName}
          onChange={(e) => setNewName(e.target.value)}
          placeholder={Locale.ui_renameNewName || "Enter new name"}
          className='rename-modal-input'
        />
        <div className='rename-modal-buttons'>
          <button
            onClick={onClose}
          >
            {Locale.ui_cancel || "Cancel"}
          </button>
          <button
            onClick={handleSubmit}
          >
            {Locale.ui_submit || "Submit"}
          </button>
        </div>
      </div>
    </div>
  );
};

export default RenameModal;
