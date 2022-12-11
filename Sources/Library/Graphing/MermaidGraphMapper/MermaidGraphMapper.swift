import DirectedGraph
import DirectedGraphMapper
import StringIndentHelpers

public struct MermaidGraphMapper: DirectedGraphMapper {
    private let settings: MermaidGraphSettings

    public init(settings: MermaidGraphSettings = MermaidGraphSettings()) {
        self.settings = settings
    }

    public func map(_ graph: DirectedGraph) throws -> String {
        return graph.stringRepresentation(withSettings: settings)
    }
}

extension DirectedGraph {
    func stringRepresentation(withSettings settings: MermaidGraphSettings) -> String {
        return [
            "graph LR",
            [
                clusters.stringRepresentation(withSettings: settings),
                edges.stringRepresentation
            ].indented.joined(separator: "\n\n")
        ].joined(separator: "\n")
    }
}

extension DirectedGraph.Cluster {
    func stringRepresentation(withSettings settings: MermaidGraphSettings) -> String {
        var lines = ["subgraph \(name)[\(label)]"]
        lines += [settings.stringRepresentation.indented]
        lines += nodes.map(\.stringRepresentation).indented
        lines += ["end"]
        return lines.joined(separator: "\n")
    }
}

extension DirectedGraph.Node {
    var stringRepresentation: String {
        switch shape {
        case .box:
            return name + "[" + label + "]"
        case .ellipse:
            return name + "([" + label + "])"
        }
    }
}

extension DirectedGraph.Edge {
    var stringRepresentation: String {
        return "\(sourceNode.name) --> \(destinationNode.name)"
    }
}

extension Array where Element == DirectedGraph.Cluster {
    func stringRepresentation(withSettings settings: MermaidGraphSettings) -> String {
        return map { $0.stringRepresentation(withSettings: settings) }.joined(separator: "\n\n")
    }
}

extension Array where Element == DirectedGraph.Edge {
    var stringRepresentation: String {
        return map(\.stringRepresentation).joined(separator: "\n")
    }
}
