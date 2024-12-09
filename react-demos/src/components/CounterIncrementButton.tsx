import { useMyContext } from "../myContext";
import { useComplexThing } from "../useComplexThing";

function CounterIncrementButton() {
  const { incrementCounter, anotherFunction } = useComplexThing();
  const { func } = useMyContext();

  const handleClick = () => {
    incrementCounter();
    anotherFunction(func)
  }

  return (<div>
    <h4>Counter Increment Button</h4>
    <button onClick={handleClick}>Increment</button>
  </div>);

}

export default CounterIncrementButton;
