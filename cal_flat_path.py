import numpy as np
from PIL import Image
import scipy.io as io
from scipy.spatial import Delaunay
import heapq
from matplotlib.figure import Figure
from rdp import rdp
from scipy.signal import savgol_filter
import argparse


class CalBestPath:
    def __init__(self, file_name, sample_ratio, epsilon, smooth_window):
        level_n = 1
        self.levels = [100 for i in range(level_n)]
        self.img = Image.open(file_name)
        self.imgL = self.img.convert('L')
        self.sample_ratio = sample_ratio
        self.smooth_window = smooth_window
        self.epsilon = epsilon
        self.initialize_sample()

    def initialize_sample(self):
        self.tempfig= Figure().subplots(1, 1)
        self.contours = self.tempfig.contour(self.imgL, origin='image', levels=sorted(set(self.levels)))
        raw_data = []
        reverse_idx = {}
        for seg in self.contours.allsegs:
            for poly in seg:
                poly = np.array(poly) / max(self.img.width, self.img.height)
                poly = (np.array(poly) * 1000).astype(int) / 1000
                poly = [tuple(p) for p in poly]
                poly2 = []
                for p in poly:
                    if p not in reverse_idx:
                        reverse_idx[p] = len(reverse_idx)
                        raw_data.append(np.array(p))
                        poly2.append(p)
        raw_data = np.array(raw_data)
        indices = np.random.choice(len(raw_data), int(len(raw_data) * self.sample_ratio), replace=False)
        self.samples = raw_data[indices]

    def mst(self):
        n = len(self.samples)
        tri = Delaunay(self.samples)
        g = [[] for i in range(n)]
        edges = {}
        nodes = set()
        for simplex in tri.simplices:
            nodes |= set(simplex)
            for k in range(3):
                i, j = simplex[k - 1], simplex[k]
                edge = min(i, j), max(i, j)
                if edge not in edges:
                    edges[edge] = np.linalg.norm(self.samples[i] - self.samples[j])
        pq = [(d, i, j) for ((i, j), d) in edges.items()]
        heapq.heapify(pq)
        p = list(range(n))

        def find(i):
            if p[i] == i:
                return i
            p[i] = find(p[i])
            return p[i]
        cc = len(nodes)
        while cc > 1:
            d, i, j = heapq.heappop(pq)
            if find(i) != find(j):
                p[find(i)] = find(j)
                g[i].append((j, d))
                g[j].append((i, d))
                cc -= 1
        return g

    def find_farthest_leaf_pair(self, g):
        def dfs(i, parent):
            farthest_leaf = i
            farthest_leaf_dis = 0
            farthest_leaf_pair = None
            farthest_leaf_pair_dis = -1
            leave_dis = []
            for j, _ in g[i]:
                if j == parent:
                    continue
                l, ld, pair, pair_dis = dfs(j, i)
                leave_dis.append((ld + 1, l))
                if ld + 1 > farthest_leaf_dis:
                    farthest_leaf_dis = ld + 1
                    farthest_leaf = l
                if farthest_leaf_pair_dis < pair_dis:
                    farthest_leaf_pair = pair
                    farthest_leaf_pair_dis = pair_dis
            if len(leave_dis) >= 2:
                (d1, l1), (d2, l2) = sorted(leave_dis)[-2:]
                if d1 + d2 > farthest_leaf_pair_dis:
                    farthest_leaf_pair_dis = d1 + d2
                    farthest_leaf_pair = l1, l2
            return farthest_leaf, farthest_leaf_dis, farthest_leaf_pair, farthest_leaf_pair_dis

        for i in range(len(g)):
            if len(g[i]):
                l, ld, pair, pair_dis = dfs(i, -1)
                if len(g[i]) == 1 and ld > pair_dis:
                    return i, l
                return pair

    def rearange_children_order(self, g, st, ed):
        vis = set()
        def dfs(i):
            vis.add(i)
            if i == ed:
                return True
            for j in range(len(g[i])):
                if g[i][j][0] not in vis:
                    if dfs(g[i][j][0]):
                        g[i][j], g[i][-1] = g[i][-1], g[i][j]
                        return True
            return False
        dfs(st)
        return st, ed

    def generate_path(self, g, st, ed):
        res = []
        vis = set()
        def dfs(i):
            vis.add(i)
            res.append(self.samples[i])
            if i == ed:
                return True
            leaf = True
            for j, _ in g[i]:
                if j not in vis:
                    leaf = False
                    if dfs(j):
                        return True
            if not leaf:
                res.append(self.samples[i])
            return False
        dfs(st)
        return res

    def smooth_path(self, path):
        path = np.array(path)
        path[:, 0] = savgol_filter(path[:, 0], self.smooth_window, 2)
        path[:, 1] = savgol_filter(path[:, 1], self.smooth_window, 2)
        return path

    def rdp_downsample(self, path):
        if self.epsilon == 0:
            return path
        before_n = len(path)
        path = rdp(path, epsilon=self.epsilon)
        after_n = len(path)
        print(f'rdp reduce points from {before_n} to {after_n}')
        return path

    def main(self):
        g = self.mst()
        st, ed = self.find_farthest_leaf_pair(g)
        self.rearange_children_order(g, st, ed)
        path = self.generate_path(g, st, ed)
        max_dis = max([np.linalg.norm(path[i - 1] - path[i])
                       for i in range(1, len(path))])
        if np.linalg.norm(self.samples[st] - self.samples[ed]) < 2 * max_dis:
            path.append(self.samples[st])
        path = self.smooth_path(path)
        path = self.rdp_downsample(path)
        return path


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file_name', type=str,
                        help='path to img file', default='shanda_icon.png')
    args = parser.parse_args()
    # 设置轨迹样本点数量以及rdp算法参数
    sample_ratio = 0.68
    epsilon = 0.001
    smooth_window = 11
    # 初始化类
    cbp = CalBestPath(args.file_name, sample_ratio, epsilon, smooth_window)
    result = cbp.main()
    # 保存结果为mat
    io.savemat('path_cal.mat', {'writing_path': result})
