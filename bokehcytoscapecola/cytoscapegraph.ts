import {LayoutDOM, LayoutDOMView} from 'models/layouts/layout_dom'
import * as p from 'core/properties'
import {LayoutItem} from "core/layout"
import {ColumnDataSource} from "models/sources/column_data_source"


declare class cytoscape {
    constructor(params: any);
    add(data: any): any;
    elements(): any;
    layout(params: any): any;
    resize(): void;
    fit(): void;
}
interface NodeEntry {
    id: any;
    [key: string]: any;
}

interface EdgeEntry {
    source: any
    target: any
    [key: string]: any
}

interface LayoutEntry {
    name: any
    [key: string]: any
}

export class CytoscapeGraphView extends LayoutDOMView {
    model: CytoscapeGraph;
    private _cy: any;
    private nodes_updated: boolean;
    private edges_updated: boolean;

    private layout_options: any;

    initialize() {
        super.initialize();

        console.log(this.el)

        this._cy = null;

        this.nodes_updated = false;
        this.edges_updated = false;

        this.connect(this.model.node_source.change, () => {
          return this.try_update_data('nodes');
        });
        this.connect(this.model.edge_source.change, () => {
          return this.try_update_data('edges');
        });

        this.layout_options = this.model.layout_options;

        if (this.model.ideal_edge_length_function) {
          const func = new Function("e", this.model.ideal_edge_length_function);

          if (this.model.layout_type === "cola") {
            return this.layout_options['edgeLength'] = func;
          } else {
            return console.warn("Ideal edge length function ignored as we don't know how to apply it to the layout");
          }
        }
      }

      render() {
        super.render();

        this._cy = new cytoscape({
          container: this.el,
          autounselectify: true,
          boxSelectionEnabled: false,
          style: this.model.style
        });
        console.log(this.el)
        return this.update_data();
      }


    try_update_data(updated_source: string): void {

        // Do not re-render unless both nodes and edges updated
        if (updated_source === 'nodes') {
          this.nodes_updated = true;
        }

        if (updated_source === 'edges') {
          this.edges_updated = true;
        }

        if (this.nodes_updated && this.edges_updated) {
          this.update_data();
        }

    }


    update_data(): void {
        let col, i, vals;
        const { node_source } = this.model;
        const { edge_source } = this.model;

        this._cy.elements().remove();

        const ids = node_source.get_column(this.model.node_index)

        if (ids === null) {
            console.error('Cannot fetch the node index column from data source')
            return
        }

        let node_length = node_source.get_length();
        let edge_length = edge_source.get_length();
        if (node_length === null) {
            console.error('Something went wrong, node source length is undefined')
            return
        }

        if (edge_length === null) {
            console.error('Something went wrong, edge source length is undefined')
            return
        }

        let entry: NodeEntry;
        for (i = 0; i < node_length; i++) {
          entry = {
            id: ids[i],
          };

          for (col in node_source.data) {
            vals = node_source.data[col];
            if (col === this.model.node_index) {
              continue;
            }

            entry[col] = vals[i];
          }


          this._cy.add({data: entry});
        }



        const froms = edge_source.get_column('from');
        const tos = edge_source.get_column('to');

        if (froms === null) {
            console.error('Cannot fetch "from" column from data source')
            return
        }

        if (tos === null) {
            console.error('Cannot fetch "to" column from data source')
            return
        }

        let d: EdgeEntry

        for (i = 0; i <= edge_length; i++) {
          d = {
            source: froms[i],
            target: tos[i]
          };

          for (col in edge_source.data) {
            vals = edge_source.data[col];
            if ((col === 'from') || (col === "to")) {
              continue;
            }

            d[col] = vals[i];
          }

          this._cy.add({data: d});
        }

        let lyt:LayoutEntry = {name: this.model.layout_type};
        for (let k in this.layout_options) {
          const v = this.layout_options[k];
          lyt[k] = v;
        }

        // Re-run layout
        this._cy.layout(lyt).run();

        this.nodes_updated = false;
        this.edges_updated = false;
    }

    get child_models(): LayoutDOM[] {
        return []
    }


    update_position(): void {
        super.update_position();
         if (this._cy !== null) {
            console.log('Resizing cytoscape');
            this._cy.resize();
            this._cy.fit();
        }
    }

    _update_layout(): void {
        this.layout = new LayoutItem();
        this.layout.set_sizing(this.box_sizing());
        if (this._cy !== null) {
            console.log('Resizing cytoscape');
            this._cy.resize();
            this._cy.fit();
        }
    }
}

export namespace CytoscapeGraph {
  export type Attrs = p.AttrsOf<Props>
  export type Props = LayoutDOM.Props & {

      node_source: p.Property<ColumnDataSource>
      edge_source: p.Property<ColumnDataSource>
      node_index: p.Property<string>
      layout_type: p.Property<string>
      layout_options: p.Property<any>
      style: p.Property<string>
      ideal_edge_length_function: p.Property<string>
  }
}

export interface CytoscapeGraph extends CytoscapeGraph.Attrs {}

export class CytoscapeGraph extends LayoutDOM {

    properties: CytoscapeGraph.Props
    constructor(attrs?: Partial<CytoscapeGraph.Attrs>) {
        super(attrs)
    }

    static initClass() {

      // This is usually boilerplate. In some cases there may not be a view.
      this.prototype.default_view = CytoscapeGraphView;

      this.prototype.type = "CytoscapeGraph";

      this.define<CytoscapeGraph.Props>({
        node_source: [p.Instance],
        edge_source: [p.Instance],

        node_index: [p.String, "index"],

        layout_type: [p.String, "cola"],
        layout_options: [p.Any, {}],

        style: [p.String, ""],

        ideal_edge_length_function: [p.String, ""]
      });
    }
};

CytoscapeGraph.initClass()