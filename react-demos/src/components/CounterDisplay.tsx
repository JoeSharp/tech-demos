import { useComplexThing } from '../useComplexThing';

function CounterDisplay() {
  const { state: { counter } } = useComplexThing();

  return (<div>
    <h4>Counter Display</h4>
    <p>Value: {counter}</p>
  </div>);
}

export default CounterDisplay;
