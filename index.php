<?php
require_once "dbConnect.php";

// Q1
if (isset($_POST['searchItem'])) {
    $searchValue = $_POST['searchValue'];
    $searchType = $_POST['searchType'];

    if ($searchType === 'name') {
        $sql = "SELECT * FROM item WHERE Iname = ?";
    } else {
        $sql = "SELECT * FROM item WHERE iId = ?";
    }

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $searchValue);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {
      echo '<div class="amBack">
                <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
                <p class="data">User Not Found</p>
              </div>';
    } else {
      while ($row = $result->fetch_assoc()) {
        echo '<div class="amBack">
                <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
                <p class="data">Item ID: ' . $row['iId'] . ' | Item Name: ' . $row['Iname'] . ' | Selling Price: ' . $row["Sprice"] . '</p>
              </div>';
      }      
    }
    

$stmt->close();
}

if (isset($_POST['addItem'])) {
  $itemName = $_POST['itemName'];
  $itemPrice = $_POST['itemPrice'];
  $itemId = generateId($conn);

  $sql = "INSERT INTO item (iId, Iname, Sprice) VALUES (?, ?, ?)";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("isi", $itemId, $itemName, $itemPrice);
  $success = $stmt->execute();
  $stmt->close();

  if ($success) {
    echo '<div class="amBack">
            <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
            <p class="data">Item added successfully!</p>
          </div>';
  } else {
    echo '<div class="amBack">
            <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
            <p class="data">Error adding item. Please try again.</p>
          </div>';
  }
}


function generateId($conn, $id = 0) {
  if ($id == 0) {
      $sql = "SELECT COUNT(*) as count FROM item";
      $result = $conn->query($sql);
      $row = $result->fetch_assoc();
      $id = $row['count'] + 1;
  }
  
  $sql = "SELECT iId FROM item WHERE iId = $id";
  $result = $conn->query($sql);
  
  if ($result->num_rows > 0) {
      // ID exists, increment and call the function again
      return generateId($conn, $id + 1);
  } else {
      // ID doesn't exist, return the ID
      return $id;
  }
}



// Q3
if (isset($_POST['updateItem'])) {
  $itemId = $_POST['itemId'];
  $newItemName = $_POST['newItemName'];
  $newItemPrice = $_POST['newItemPrice'];

  $sql = "UPDATE item SET Iname = ?, Sprice = ? WHERE iId = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("sii", $newItemName, $newItemPrice, $itemId);
  $success = $stmt->execute();
  $stmt->close();

  if ($success) {
    echo '<div class="amBack">
            <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
            <p class="data">Item updated successfully!</p>
          </div>';
  } else {
    echo '<div class="amBack">
            <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
            <p class="data">Error updating item. Please try again.</p>
          </div>';
  }
}


// Q4
if (isset($_POST['deleteItem'])) {
  $itemId = $_POST['itemId'];

  // First, delete related records from the order_item table
  $sql = "DELETE FROM order_item WHERE iId = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("i", $itemId);
  $stmt->execute();
  $stmt->close();

  // Next, delete related records from the oldprice table
  $sql = "DELETE FROM oldprice WHERE iId = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("i", $itemId);
  $stmt->execute();
  $stmt->close();

  // Then, delete related records from the store_item table
  $sql = "DELETE FROM store_item WHERE iId = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("i", $itemId);
  $stmt->execute();
  $stmt->close();

  // Also, delete related records from the vendor_item table
  $sql = "DELETE FROM vendor_item WHERE iId = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("i", $itemId);
  $stmt->execute();
  $stmt->close();

  // Finally, delete the item from the item table
  $sql = "DELETE FROM item WHERE iId = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("i", $itemId);
  $success = $stmt->execute();
  $stmt->close();

  if ($success) {
    echo '<div class="amBack">
            <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
            <p class="data">Item deleted successfully!</p>
          </div>';
  } else {
    echo '<div class="amBack">
            <div class="minimizeButton" onclick="toggleAmBack(this)">-</div>
            <p class="data">Error deleting item. Please try again.</p>
          </div>';
  }
}




// The view-based queries (QV1-QV5) can be executed and displayed similarly to the other questions, by first checking if
//an appropriate form has been submitted, and then running the query and displaying the results. Note that you will need
//to create the SQL views for these queries before executing them in PHP.

$conn->close();
?>

<!DOCTYPE html>
<html>

<head>
    <title>Database Prod</title>
    <!--Link to water css-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
    <link rel="stylesheet" href="./assets/css/awesome.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@200;300;400;500;600;700;800;900&display=swap"
        rel="stylesheet">
</head>

<body>

    <div class="container">


        <!--dropdown a div-->
        <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton1"
                data-bs-toggle="dropdown" aria-expanded="false">
                Search Item
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                <h2>Search Item by Name or ID</h2>
                <form method="POST" action="index.php">
                    <div class="selectBox">
                        <label for="searchType">Search by:</label>
                        <select name="searchType" id="searchType">
                            <option value="name">Name</option>
                            <option value="id">ID</option>
                        </select>
                    </div>
                    <input type="text" name="searchValue" placeholder="Enter name or ID">
                    <input type="submit" name="searchItem" value="Search">
                </form>
            </ul>
        </div>

        <!--dropdown a div-->
        <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton1"
                data-bs-toggle="dropdown" aria-expanded="false">
                Add New
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                <!-- Q2: Add new item -->
                <h2>Add New Item</h2>
                <form method="POST" action="index.php">
                    <input type="text" name="itemName" placeholder="Item name">
                    <input type="number" name="itemPrice" placeholder="Selling price">
                    <input type="submit" name="addItem" value="Add Item">
                </form>
            </ul>
        </div>


        <!--dropdown a div-->
        <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton1"
                data-bs-toggle="dropdown" aria-expanded="false">
                Update Item
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                <!-- Q3: Update item details -->
                <h2>Update Item Details</h2>
                <form method="POST" action="index.php">
                    <input type="number" name="itemId" placeholder="Item ID">
                    <input type="text" name="newItemName" placeholder="New item name">
                    <input type="number" name="newItemPrice" placeholder="New selling price">
                    <input type="submit" name="updateItem" value="Update Item">
                </form>
            </ul>
        </div>
        <!--dropdown a div-->
        <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton1"
                data-bs-toggle="dropdown" aria-expanded="false">
                Delete Item
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                <!-- Q4: Delete item -->
                <h2>Delete Item</h2>
                <form method="POST" action="index.php">
                    <input type="number" name="itemId" placeholder="Item ID">
                    <input type="submit" name="deleteItem" value="Delete Item">
                </form>
            </ul>
        </div>
        <script src="./assets/js/awesome.js"></script>
    </div>
</body>

</html>