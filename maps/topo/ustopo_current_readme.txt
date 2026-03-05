Metadata Overview
Topics .... USGS topographic maps, current and historical.
Contents .. General product inventory metadata and summary storage estimates.
Formats ... Plain-text and comma-separated value (CSV) files.

Available Series
US Topo Current Editions
ustopo_current.zip 
Only the latest topographic maps in the US Topo series.
Indexed with the Geographic Names Information System (GNIS) cells database to 
provide simplified filenames* and a standardized directory structure.
Products are distributed with vector and orthoimagery layers in Geospatial PDF.
*Files in this category do not include a production date in the name.


Column Descriptions
Availability may vary by series.

gnis_cell_id ............. Identifies the cell index of the current map product 
                           according to the official gazetteer cells database. 
                           The coordinate boundaries of all US Topo maps are 
                           consistent with those recorded in the 7.5-Minute 
                           cell index.
                           Type: large-range integer (8 bytes)
                           Domain: positive whole numbers

product_auth_id .......... Authorization for production of a map covering an 
                           extent of the cell index. Used for versioning new 
                           releases. Unique for all distributed products in 
                           this series. 
                           Type: large-range integer (8 bytes)
                           Domain: positive whole numbers

series ................... General collection or broad categorization of map 
                           products. May encompass multiple formats or 
                           variations in product standards over time.
                           Type: text
                           Domain: US Topo.

edition .................. Indicates whether this product is the latest 
                           representation on record for the map extent.
                           US Topo only: At most one current product may be 
                           released for each 7.5-Minute cell index.
                           See date on map for the year of the edition.
                           Type: text
                           Domain: Current, Historical

map_name ................. The current official name or title of the map.
                           Source: gazetteer cells and features
                           Type: text
                           Domain: place names and printed sheet titles
                           Note: official terms may vary from displayed or 
                           printed text in historical maps.

primary_state ............ The current official state name. 
                           Source: gazetteer cells and features
                           Type: text 
                           Domain: common names of U.S. states and 
                           territories, provinces, and other political regions.
                           Note: official terms may vary from displayed or 
                           printed text in historical maps.

westbc ................... The west bounding coordinate of the product spatial 
                           extent, measured in angle of longitude.
                           Type: numeric
                           Domain: -180.0, 180.0 (decimal degrees)

eastbc ................... The east bounding coordinate of the product spatial 
                           extent, measured in angle of longitude.
                           Type: numeric
                           Domain: -180.0, 180.0 (decimal degrees)

northbc .................. The north bounding coordinate of the product spatial 
                           extent, measured in angle of latitude.
                           Type: numeric
                           Domain: -90.0, 90.0 (decimal degrees)

southbc .................. The south bounding coordinate of the product spatial 
                           extent, measured in angle of latitude.
                           Type: numeric 
                           Domain: -90.0, 90.0 (decimal degrees)

grid_size ................ The spatial dimension of the standard cell index.
                           Typically comprised of a fixed national grid.
                           Type: text
                           Domain: Official cell grids
                           US Topo: 7.5 x 7.5 Minute (All Maps)

cell_type ................ Relation of the spatial extent to the fixed cell grid
                           Appearance typically varies by region.
                           Type: text
                           Domain: Official cell types
                           US Topo: Standard On-Grid (All States), 
                           Standard Off-Grid (HI-Only), Oversized (AK-Only)

nrn ...................... NGA Reference Number, component of bar-code.
                           Series: US Topo Only
                           Current Editions Only: Registered as a unique 
                           identifier in ScienceBase.
                           Type: text
                           Domain: organization, map scale, and GNIS Cell ID.

nsn ...................... DLA National Stock Number, the bar-code value. 
                           Series: US Topo Only
                           Current Editions Only: Registered as a unique 
                           identifier in ScienceBase.
                           Type: large-range integer (8 bytes)
                           Domain: positive non-zero integers

state_list ............... List of state abbreviations based off the cell index 
                           and gazetteer features database.
                           Type: text 
                           Domain: short code abbreviations of U.S. states and 
                           territories, provinces, and other political regions.

county_list .............. List of counties or equivalent regions that intersect 
                           the boundary of the map according to the gazetteer 
                           features database.
                           Type: text
                           Domain: government units

date_on_map .............. Year of the product edition.
                           Production of new maps may be limited by data 
                           availability in some regions.
                           Type: integer
                           Domain: calendar years (varies by series)

publication_date ......... Year in which the map product was first released.
                           Applies to both digital and print variations.
                           Type: date
                           Domain: dates starting date varies by series
                           Source: Original product metadata

production_date .......... Original content production date.
                           Source: filename
                           Type: date
                           Domain: ISO 8601

orthoimagery_date ........ The final collection date given for the orthoimagery 
                           source layer, according to the product metadata or 
                           printed text.
                           Type: date
                           Domain: ISO 8601

distribution_date ........ Last update to the distributed metadata record. 
                           Type: date
                           Domain: standard calendar dates
                           Note: Data distribution activities are not always 
                           reflective of changes to content of the original 
                           map product.

map_scale ................ The quotient of ratio for spatial reproduction
                           of map content to the printed page.
                           Type: integer
                           Domain: 24000 (Standard), 25000 (AK), 20000 (PR/VI)

page_width_inches ........ The calculated dimension (left to right) of the 
                           digital document page in inches.
                           US Topo Only: Fixed, region or scale dependent
                           Type: numeric
                           Domain: positive non-zero numeric values

page_height_inches ....... The calculated dimension (left to right) of the 
                           digital document page in inches.
                           US Topo Only: Fixed, region or scale dependent
                           Type: numeric
                           Domain: positive non-zero numeric values

original_product ......... Full name of the current edition as it appears in the 
                           main collection. Includes the original production 
                           date. A copy of this file was made for this special 
                           collection.
                           Type: text
                           Domain: valid filenames
                           ustopo_historical: "<CellState> <CellName> 
                           <ProductionDate> <Projection>"

product_filename ......... Name of the digital deliverable for this product.
                           Files in the Current Edition collection have been 
                           standardized according to the official GNIS records.
                           Type: text
                           Domain: valid filenames
                           ustopo_current: "<CellState> <CellName>"

product_filesize ......... Calculated measure of storage space occupied by the 
                           primary deliverable within a digital filesystem. 
                           Type: large-range integer (8 bytes)
                           Domain: positive whole numbers

product_inventory_uuid ... Universally unique identifier for a product within 
                           the inventory system. Associates a spatial dataset 
                           to content within a product class or series. 
                           Retained between replacements for same edition.
                           Note: Designed to be re-usable if the products are 
                           re-issued under different headings. Retention for 
                           non-cell based product may be impacted by changes 
                           in reported spatial boundary.
                           Registered as an identifier in ScienceBase.
                           Type: UUID
                           Domain: RFC-4122

db_uuid .................. Unique identifier for a registered product metadata 
                           record. Retained between replacements based on 
                           authorization status.
                           Type: UUID
                           Domain: RFC-4122

inv_uuid ................. The distributed instance of the original product 
                           metadata. At most one active per loaded record.
                           May be used in combination with the "db_uuid" field 
                           to track replacements and changes in publication.
                           Type: UUID
                           Domain: RFC-4122

product_url .............. Internet location of the primary deliverable.
                           Current US Topo Only: path does not change between 
                           versions or production years.
                           Type: text
                           Domain: RFC-1738

thumbnail_url ............ Internet location of a raster graphic representing 
                           the digital map product.
                           Current US Topo Only: path does not change between 
                           versions or production years.
                           Type: text
                           Domain: RFC-1738
 
sciencebase_url .......... Internet location of the published entry in the 
                           ScienceBase public catalog. Existing items will 
                           often receive updates between editions. 
                           Note: URLs are not persistent and cannot be reused 
                           once a product is removed.
                           Product Inventory UUID values will be retained for 
                           the same original content.
                           Type: text
                           Domain: RFC-1738

metadata_url ............. Internet location of the distributed version of the 
                           product metadata in XML format as maintained by the 
                           inventory system.
                           Type: text
                           Domain: RFC-1738

geom_wkt ................. Well-Known Text representation of the cell geometry.
                           Type: text
                           Domain: WGS84 Spatial Reference System Coordinates


Examples
ustopo_current - current editions with standardized names copied from the main 
                 collection
1. The latest version in the US Topo series for this cell.
   A copy of this same product is also provided in the main collection with the 
   original production date.

Values presented are accurate at the time of reporting.

[ RECORD 1 ]----------+---------------------------------------------------------
gnis_cell_id           | 27199
product_auth_id        | 1427247
series                 | US Topo
edition                | Current
map_name               | Madison West
primary_state          | Wisconsin
westbc                 | -89.50000000
eastbc                 | -89.37500000
northbc                | 43.12500000
southbc                | 43.00000000
grid_size              | 7.5 X 7.5 Minute
cell_type              | Standard on Grid
nrn                    | USGSX24K27199
nsn                    | 7643016403431
state_list             | WI
county_list            | Dane
date_on_map            | 2022
publication_date       | 2022-01-27
production_date        | 2022-01-27
orthoimagery_date      | 2018-10-04
distribution_date      | 2022-01-28
map_scale              | 24000
page_width_inches      | 24
page_height_inches     | 29
original_product       | WI_Madison_West_20220127_TM_geo.pdf
product_filename       | WI_Madison_West.pdf
product_format         | Geospatial PDF
product_filesize       | 36268224
product_inventory_uuid | ebe68259-6e4e-383d-d8d7-f685b51b3b86
db_uuid                | 9d31011a-a590-2a7b-7cbf-eff88de3d730
inv_uuid               | c08e344f-638a-5234-ab6b-2d31304dd965
product_url            | https://prd-tnm.s3.amazonaws.com/StagedProducts/Maps
                         /USTopo/Current/PDF/WI/WI_Madison_West.pdf
                         
thumbnail_url          | https://prd-tnm.s3.amazonaws.com/StagedProducts/Maps
                         /USTopo/Current/PDF/WI/WI_Madison_West.jpg
                         
sciencebase_url        | https://www.sciencebase.gov/catalog
                         /item/61f4aac2d34e622189bc6535
                         
metadata_url           | https://thor-f5.er.usgs.gov/ngtoc/metadata/waf/maps
                         /ustopo/pdf/WI/WI_Madison_West_20220127_TM_geo.xml
                         
geom_wkt               | POLYGON((-89.375 43,-89.375 43.125,-89.5 43.125,
                         -89.5 43,-89.375 43))


Changelog
2024-03-06 Renamed metadata_date to distribution_date
           Renamed imagery_source_date to orthoimagery_date
           Added production_date, product_auth_id, original_product
           Moved geom_wkt to end
