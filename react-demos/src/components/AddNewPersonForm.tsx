import React from 'react';
import { useComplexThing } from "../useComplexThing";

function AddNewPersonForm() {
  const { createNewAdult } = useComplexThing();

  const [newName, setNewName] = React.useState('charlie');

  const onNewNameChange: React.ChangeEventHandler<HTMLInputElement> = React.useCallback(e => {
    setNewName(e.target.value);
  }, []);

  return (<div>
      <label>New Name</label>
      <input type="text" value={newName} onChange={onNewNameChange} />
      <button onClick={() => createNewAdult(newName)}>Add</button>
    </div>);
}

export default AddNewPersonForm;
