import AddNewPersonForm from "./AddNewPersonForm";
import PeopleTable from "./PeopleTable";

function PersonManager() {

  return (<div>
    <h3>People</h3>
    <PeopleTable />
    <AddNewPersonForm />
  </div>)
}

export default PersonManager;
