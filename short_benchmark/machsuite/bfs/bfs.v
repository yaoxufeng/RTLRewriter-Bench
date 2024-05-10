`define MAX_N_EDGES 158
`define N_NODES 16
`define N_EDGES 16
`define N_LEVELS 16
`define MAX_LEVEL 200

module bfs (
    input [32:1] nodes,
    input [32:1] edges,
    input [4:0] starting_node,
    inout [15:0] level,
    inout [15:0] level_counts
);
    integer n;
    integer horizon;
    integer i;
    reg [4:0] edge_index;
    reg [4:0] cnt;

    always @(nodes,edges,starting_node) begin
        level[starting_node] = 0;
        level_counts[0] = 1;

        for(horizon=0; horizon<N_LEVELS; horizon=horizon+1) begin
            cnt = 0;
            for(n=0; n<N_NODES; n=n+1) begin
                if(level[n]==horizon) begin
                    edge_index = nodes[2*n];
                    reg [4:0] tmp_end = nodes[2*n+1];
                    for(i=0; i<MAX_N_EDGES; i=i+1) begin
                        if(edge_index < tmp_end) begin
                            reg [4:0] tmp_dst = edges[2*edge_index];
                            reg [4:0] tmp_level = level[tmp_dst];
                            if(tmp_level==MAX_LEVEL) begin
                                level[tmp_dst]=horizon+1;
                                cnt = cnt + 1;
                            end
                        end
                        edge_index = edge_index + 1;
                    end
                end
            end
            if(cnt == 0)
                break;
            else
                level_counts[horizon+1] = cnt;
        end
    end
endmodule