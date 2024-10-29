import React from 'react';
import { useComplexThing } from "../useComplexThing";

function PeopleTable() {
  const {state: {people}, incrementAge, removePerson} = useComplexThing();

  // A bit unweildy, but shows how you can memo-ise the click functions
  // By pulling data from the target
  const onIncrementAge = React.useCallback((e: React.SyntheticEvent<HTMLButtonElement>) => {
    const name = e.currentTarget.dataset.personname;
    if (!name) {
      console.error('personname missing from element');
      return;
    }
    incrementAge(name);
  }, [incrementAge]);

  const onRemove = React.useCallback((e: React.SyntheticEvent<HTMLButtonElement>) => {
    const name = e.currentTarget.dataset.personname;
    if (!name) {
      console.error('personname missing from element');
      return;
    }
    removePerson(name);
  }, [removePerson]);

  return (<table>
    <thead>
      <tr><th>Name</th><th>Age</th><th>Increment</th><th>Remove</th></tr>
    </thead>
    <tbody>
      {people.map(person => (<tr key={person.name}>
        <td>{person.name}</td>
        <td>{person.age}</td>
        <td><button data-personname={person.name} onClick={onIncrementAge}>Birthday!</button></td>
        <td><button data-personname={person.name} onClick={onRemove}>Remove</button></td>
      </tr>
      ))}
    </tbody>
  </table>);
}

export default PeopleTable;
